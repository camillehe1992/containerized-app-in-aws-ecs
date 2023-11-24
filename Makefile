#########################################################################
# Terraform Makefile
#########################################################################
-include .env

SHELL := /bin/bash
BASE := $(shell /bin/pwd)
PIP ?= pip
TF ?= terraform

# The deployment name, shared or app
DEPLOYMENT_PATH := $(BASE)/terraform/deployment/$(DEPLOYMENT)
VAR_FILE := $(BASE)/terraform/environments/$(ENVIRONMENT).tfvars

$(info AWS_ACCOUNT 		= $(AWS_ACCOUNT))
$(info AWS_PROFILE 		= $(AWS_PROFILE))
$(info AWS_REGION  		= $(AWS_REGION))
$(info STATE_BUCKET		= $(STATE_BUCKET))
$(info ENVIRONMENT 		= $(ENVIRONMENT))
$(info NICKNAME    		= $(NICKNAME))
$(info DEPLOYMENT 		= $(DEPLOYMENT))
$(info VAR_FILE 		= $(VAR_FILE))
$(info DESIRED_COUNT 	= $(DESIRED_COUNT))

# Add defaults/common variables for all components
define DEFAULTS
-var-file=$(VAR_FILE) \
-var aws_profile=$(AWS_PROFILE) \
-var aws_region=$(AWS_REGION) \
-var environment=$(ENVIRONMENT) \
-var nickname=$(NICKNAME) \
-refresh=true
endef

# Add app specific variables
define APP_VARS
-var state_bucket=$(STATE_BUCKET) \
-var desired_count=$(DESIRED_COUNT)
endef
 
ifeq ($(DEPLOYMENT),app)
$(info Add variables for app)
override OPTIONS += $(APP_VARS)
endif
 
override OPTIONS += $(DEFAULTS)

#########################################################################
# Convenience Functions to use in Make
#########################################################################
environments := dev prod
check-for-environment = $(if $(filter $(ENVIRONMENT),$(environments)),,$(error Invalid environment: $(ENVIRONMENT). Accepted environments: $(environments)))
deployments := shared app
check-for-deployment = $(if $(filter $(DEPLOYMENT),$(deployments)),,$(error Invalid deployment: $(DEPLOYMENT). Accepted deployments: $(deployments)))
#########################################################################
# CICD Make Targets
#########################################################################
lint:
	$(info [*] Linting terraform)
	@$(TF) fmt -check -diff -recursive
	@$(TF) validate

pre-check:
	$(info [*] Check Environment Done)
	@$(call check-for-environment)
	@$(call check-for-deployment)
	@$(info $(shell aws sts get-caller-identity --profile $(AWS_PROFILE)))

init: pre-check
	$(info [*] Init Terrafrom Infra)
	@cd $(DEPLOYMENT_PATH) && terraform init -reconfigure \
		-backend-config="bucket=$(STATE_BUCKET)" \
		-backend-config="region=$(AWS_REGION)" \
		-backend-config="profile=$(AWS_PROFILE)" \
		-backend-config="key=$(NICKNAME)/$(ENVIRONMENT)/$(AWS_REGION)/$(DEPLOYMENT).tfstate"

plan: init
	$(info [*] Plan Terrafrom Infra)
	@cd $(DEPLOYMENT_PATH) && terraform plan $(OPTIONS) -out tfplan

plan-destroy: init
	$(info [*] Plan Terrafrom Infra - Destroy)
	@cd $(DEPLOYMENT_PATH) && terraform plan $(OPTIONS) -destroy -out tfplan

apply: init
	$(info [*] Apply Terrafrom Infra)
	@cd $(DEPLOYMENT_PATH) && terraform apply tfplan

apply-destroy: init
	$(info [*] Apply Terrafrom Infra - Destroy)
	@cd $(DEPLOYMENT_PATH) && terraform apply tfplan