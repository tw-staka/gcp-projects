variable "project_name" {}
variable "org_id" {}
variable "billing_account" {}

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
