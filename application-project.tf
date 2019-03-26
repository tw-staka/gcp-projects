# PROJECT CREATION
module "application_project" {
    source = "./modules/project"
    project_name = "application"
    org_id = "${var.org_id}"
    environment = "${var.environment}"
    environment_short = "${var.environment_short}"
    billing_account = "${var.billing_account}"
}

### API

resource "google_project_service" "gke" {
  project = "${module.application_project.project_id}"
  service = "container.googleapis.com"
  # If true, services that are enabled and which depend on this service should also be disabled when this service is destroyed.
  disable_dependent_services = true
  disable_on_destroy = false
}
resource "google_project_service" "container_registry" {
  project = "${module.application_project.project_id}"
  service = "containerregistry.googleapis.com"
  # If true, services that are enabled and which depend on this service should also be disabled when this service is destroyed.
  disable_dependent_services = true
  disable_on_destroy = false
}
resource "google_project_service" "container_analysis" {
  project = "${module.application_project.project_id}"
  service = "containeranalysis.googleapis.com"
  # If true, services that are enabled and which depend on this service should also be disabled when this service is destroyed.
  disable_dependent_services = true
  disable_on_destroy = false
}
resource "google_project_service" "cloudbuild" {
  project = "${module.application_project.project_id}"
  service = "cloudbuild.googleapis.com"
  # If true, services that are enabled and which depend on this service should also be disabled when this service is destroyed.
  disable_dependent_services = true
  disable_on_destroy = false
}
resource "google_project_service" "cloud_source_repository" {
  project = "${module.application_project.project_id}"
  service = "sourcerepo.googleapis.com"
  # If true, services that are enabled and which depend on this service should also be disabled when this service is destroyed.
  disable_dependent_services = true
  disable_on_destroy = false
}

### IAM
# https://cloud.google.com/iam/docs/understanding-roles#cloud-kms-roles
resource "google_project_iam_member" "cloudbuild_editor" {
  project    = "${module.application_project.project_id}"
  role       = "roles/cloudbuild.builds.editor"
  member     = "serviceAccount:${module.application_project.terraform_email}"
}
resource "google_project_iam_member" "container_admin" {
  project    = "${module.application_project.project_id}"
  role       = "roles/container.admin"
  member     = "serviceAccount:${module.application_project.terraform_email}"
}
