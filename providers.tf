# See release version here
# https://github.com/terraform-providers/terraform-provider-google/blob/master/CHANGELOG.md
provider "google" {
  version = "2.2.0"
  region  = "${var.region}"
}

provider "google-beta" {
  version = "2.2.0"
  region  = "${var.region}"
}

# Here we us remote backend to store the terraform state
# The terraform state is stored in a google cloud storage bucket inside this project
# The bucket is provisioned by the project creation creation step.
terraform {
  required_version = "0.11.13"
  backend "gcs" {}
}