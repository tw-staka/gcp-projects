# PROJECT CREATION
module "project" {
    source = "./modules/project"
    project_name = "kms-project"
    org_id = "${var.org_id}"
    environment = "${var.environment}"
    environment_short = "${var.environment_short}"
    billing_account = "${var.billing_account}"
}

### API

resource "google_project_service" "kms" {
  project = "${module.project.project_id}"
  service = "cloudkms.googleapis.com"
  # If true, services that are enabled and which depend on this service should also be disabled when this service is destroyed.
  disable_dependent_services = true
  disable_on_destroy = false
}

### IAM
# https://cloud.google.com/iam/docs/understanding-roles#cloud-kms-roles
resource "google_project_iam_member" "cloudkms_admin" {
  project    = "${module.project.project_id}"
  role       = "roles/cloudkms.admin"
  member     = "serviceAccount:${module.project.number}@cloudbuild.gserviceaccount.com"
}
