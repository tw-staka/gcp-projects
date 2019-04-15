variable "project_name" {}
variable "billing_account" {}
variable "folder_id" {}
variable "environment" {}
variable "environment_short" {}

# Use google cloud storage location
# https://cloud.google.com/storage/docs/bucket-locations
variable "terraform_state_bucket_location" {
    default = "australia-southeast1"
}
variable "terraform_state_bucket_storage_class" {
    default = "REGIONAL"
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