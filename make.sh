#!/usr/bin/env bash
# This file is a symbolic link
function terraform_validate() {
  echo "Running terraform validate"
  terraform validate -var-file $1.tfvars
}

function terraform_init() {
  echo "Running terraform validate before init"
  terraform_validate $1
  echo "Running terraform init"
  terraform init -backend-config=bucket=$2 -backend-config=prefix=$1 -reconfigure
}

function terraform_plan() {
  echo "Running terraform plan"
  terraform plan -var-file $1.tfvars
}

function extract_project_id() {
	grep project_id $1.tfvars | grep -o \".\*\" | tr -d \"
}

function terraform_apply() {
  echo "Running terraform apply"
  terraform apply -var-file $1.tfvars
}
function terraform_apply_ci() {
  echo "Running terraform apply"
  terraform apply -auto-approve -input=false -var-file $1.tfvars
}
function terraform_destroy() {
  echo "Running terraform destroy"
  terraform destroy -var-file $1.tfvars
}
