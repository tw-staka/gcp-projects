variable "org_id" {}
variable "environment" {}
variable "region" {}
variable "environment_short" {}

variable "billing_account" {
    description = "Check README for more information"
}
variable "read_access_accounts" {
    type = "list"
    default = []
    description = "Grant the roles/viewer to the project."
}

variable "read_access_to_terraform_state_file" {
    type = "list"
    default = []
    description = "Grant view access to terraform state file, this allow a developer to run terraform plan on its machine. But not apply."
}