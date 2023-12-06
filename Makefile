#########################################################################
# Terraform Makefile
#########################################################################
-include .env

SHELL := /bin/bash
BASE := $(shell /bin/pwd)
TF ?= terraform
MAKE ?= make

# The deployment name, shared or app
TF_ROOT_PATH := $(BASE)/terraform
TF_VAR_FILE := $(BASE)/terraform/environments/$(ENVIRONMENT).tfvars

$(info AWS_ACCOUNT 		= $(AWS_ACCOUNT))
$(info AWS_PROFILE 		= $(AWS_PROFILE))
$(info AWS_REGION  		= $(AWS_REGION))
$(info STATE_BUCKET		= $(STATE_BUCKET))
$(info ENVIRONMENT 		= $(ENVIRONMENT))
$(info NICKNAME    		= $(NICKNAME))
$(info IMAGE 			= $(IMAGE))
$(info DESIRED_COUNT	= $(DESIRED_COUNT))
$(info TF_VAR_FILE 		= $(TF_VAR_FILE))

# Add defaults/common variables for all components
define DEFAULTS
-var-file=$(TF_VAR_FILE) \
-var aws_profile=$(AWS_PROFILE) \
-var aws_region=$(AWS_REGION) \
-var environment=$(ENVIRONMENT) \
-var nickname=$(NICKNAME) \
-var image=$(IMAGE) \
-var desired_count=$(DESIRED_COUNT) \
-var app_keys=$(APP_KEYS) \
-var api_token_salt=$(API_TOKEN_SALT) \
-var admin_jwt_secret=$(ADMIN_JWT_SECRET) \
-var transfer_token_salt=$(TRANSFER_TOKEN_SALT) \
-var jwt_secret=$(JWT_SECRET) \
-var database_host=$(DATABASE_HOST) \
-var database_username=$(DATABASE_USERNAME) \
-var database_password=$(DATABASE_PASSWORD) \
-refresh=true -detailed-exitcode -out tfplan
endef

OPTIONS += $(DEFAULTS)

$(info OPTIONS 		= $(OPTIONS))

#########################################################################
# Convenience Functions to use in Make
#########################################################################
environments := dev prod
check-for-environment = $(if $(filter $(ENVIRONMENT),$(environments)),,$(error Invalid environment: $(ENVIRONMENT). Accepted environments: $(environments)))
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
	@$(info $(shell aws sts get-caller-identity --profile $(AWS_PROFILE)))

init: pre-check
	$(info [*] Init Terrafrom Infra)
	@cd $(TF_ROOT_PATH) && terraform init -reconfigure \
		-backend-config="bucket=$(STATE_BUCKET)" \
		-backend-config="region=$(AWS_REGION)" \
		-backend-config="profile=$(AWS_PROFILE)" \
		-backend-config="key=$(NICKNAME)/$(ENVIRONMENT)/$(AWS_REGION)/$(DEPLOYMENT).tfstate"

plan: init
	$(info [*] Plan Terrafrom Infra)
	@cd $(TF_ROOT_PATH) && terraform plan $(OPTIONS)

plan-destroy: init
	$(info [*] Plan Terrafrom Infra - Destroy)
	@cd $(TF_ROOT_PATH) && terraform plan -destroy $(OPTIONS)

apply:
	$(info [*] Apply Terrafrom Infra)
	@cd $(TF_ROOT_PATH) && terraform apply tfplan

