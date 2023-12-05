#########################################################################
# Terraform Makefile
#########################################################################
-include .env

SHELL := /bin/bash
BASE := $(shell /bin/pwd)
TF ?= terraform
MAKE ?= make

# The deployment name, shared or app
DEPLOYMENT_PATH := $(BASE)/terraform/deployments/$(DEPLOYMENT)
TF_VAR_FILE := $(BASE)/terraform/environments/$(ENVIRONMENT).tfvars

$(info AWS_ACCOUNT 		= $(AWS_ACCOUNT))
$(info AWS_PROFILE 		= $(AWS_PROFILE))
$(info AWS_REGION  		= $(AWS_REGION))
$(info STATE_BUCKET		= $(STATE_BUCKET))
$(info ENVIRONMENT 		= $(ENVIRONMENT))
$(info NICKNAME    		= $(NICKNAME))
$(info DEPLOYMENT 		= $(DEPLOYMENT))
$(info IMAGE 			= $(IMAGE))
$(info DESIRED_COUNT 	= $(DESIRED_COUNT))
$(info DEPLOYMENT_PATH 	= $(DEPLOYMENT_PATH))
$(info TF_VAR_FILE 		= $(TF_VAR_FILE))

# Add defaults/common variables for all components
define DEFAULTS
-var-file=$(TF_VAR_FILE) \
-var aws_profile=$(AWS_PROFILE) \
-var aws_region=$(AWS_REGION) \
-var environment=$(ENVIRONMENT) \
-var nickname=$(NICKNAME)
endef

OPTIONS += $(DEFAULTS)

# Add app specific variables
define APP_VARS
-var state_bucket=$(STATE_BUCKET) \
-var image=$(IMAGE) \
-var desired_count=$(DESIRED_COUNT) \
-var app_keys=$(APP_KEYS) \
-var api_token_salt=$(API_TOKEN_SALT) \
-var admin_jwt_secret=$(ADMIN_JWT_SECRET) \
-var transfer_token_salt=$(TRANSFER_TOKEN_SALT) \
-var jwt_secret=$(JWT_SECRET) \
-var database_host=$(DATABASE_HOST) \
-var database_username=$(DATABASE_USERNAME) \
-var database_password=$(DATABASE_PASSWORD)
endef

define ADDTIONAL
-refresh=true -detailed-exitcode -out tfplan
endef
 
ifeq ($(DEPLOYMENT),app)
$(info Add variables for app)
OPTIONS += $(APP_VARS)
endif

OPTIONS += $(ADDTIONAL)

$(info OPTIONS 		= $(OPTIONS))

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
	@cd $(DEPLOYMENT_PATH) && terraform plan $(OPTIONS) || export exitcode=$?

plan-destroy: init
	$(info [*] Plan Terrafrom Infra - Destroy)
	@cd $(DEPLOYMENT_PATH) && terraform plan -destroy $(OPTIONS) || export exitcode=$?

apply: init
	$(info [*] Apply Terrafrom Infra)
	@cd $(DEPLOYMENT_PATH) && terraform apply tfplan

apply-destroy: init
	$(info [*] Apply Terrafrom Infra - Destroy)
	@cd $(DEPLOYMENT_PATH) && terraform apply tfplan

apply-all: 
	$(info [*] Apply All Terrafrom Resources)
	@$(MAKE) DEPLOYMENT=shared plan
	@$(MAKE) DEPLOYMENT=shared apply
	@$(MAKE) DEPLOYMENT=app plan
	@$(MAKE) DEPLOYMENT=app apply

destroy-all: 
	$(info [*] Apply All Terrafrom Resources)
	@$(MAKE) DEPLOYMENT=app plan-destroy
	@$(MAKE) DEPLOYMENT=app apply
	@$(MAKE) DEPLOYMENT=shared plan-destroy
	@$(MAKE) DEPLOYMENT=shared apply
