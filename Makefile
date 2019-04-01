# This file is a symbolic link

ENVIRONMENT?=staging
BUCKET_STATE_PROJECT_ID=terraform-backend-state-2x2

.PHONY: all
all: plan

.PHONY: validate
validate:
	@source make.sh && terraform_validate $(ENVIRONMENT)

.PHONY: init
init:
	@source make.sh && terraform_init $(ENVIRONMENT) $(BUCKET_STATE_PROJECT_ID)

.PHONY: plan
plan: init
	@source make.sh && terraform_plan $(ENVIRONMENT)
