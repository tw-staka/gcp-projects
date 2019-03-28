# PROJECT CREATION
module "application_project" {
    source = "./modules/project"
    project_name = "application"
    org_id = "${var.org_id}"
    environment = "${var.environment}"
    environment_short = "${var.environment_short}"
    billing_account = "${var.billing_account}"
    read_access_accounts = "${var.read_access_accounts}"
    read_access_to_terraform_state_file = "${var.read_access_to_terraform_state_file}"
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

data "google_compute_default_service_account" "default" {
  project = "${module.application_project.project_id}"
 }
# Allow terraform service account to act as default compute service account
# This is required to create/update GKE clusters.
resource "google_service_account_iam_member" "gce-default-account-iam" {
  service_account_id = "${data.google_compute_default_service_account.default.name}"
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${module.application_project.terraform_email}"
}
# We need compute viewer to create a GKE cluster, more specifically compute.instanceGroupManagers.get
resource "google_project_iam_member" "compute_viewer" {
  project    = "${module.application_project.project_id}"
  role       = "roles/compute.viewer"
  member     = "serviceAccount:${module.application_project.terraform_email}"
}

resource "google_project_iam_member" "cloudbuild_editors" {
  count         = "${length(var.cloudbuild_editors)}"
  project    = "${module.application_project.project_id}"
  role       = "roles/cloudbuild.builds.editor"
  member     = "${var.cloudbuild_editors[count.index]}"
}

# Grant Cloud Build access to GKE
resource "google_project_iam_member" "cloudbuild_container_developer" {
  project   = "${module.application_project.project_id}"
  role      = "roles/container.developer"
  member    = "serviceAccount:${module.application_project.number}@cloudbuild.gserviceaccount.com"
}
