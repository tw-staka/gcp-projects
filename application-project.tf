# PROJECT CREATION
module "application_project" {
    source = "./modules/project"
    project_name = "application"
    environment = "${var.environment}"
    environment_short = "${var.environment_short}"
    billing_account = "${var.billing_account}"
    read_access_accounts = "${var.read_access_accounts}"
    read_access_to_terraform_state_file = "${var.read_access_to_terraform_state_file}"
    folder_id = "${var.folder_id}"
}

### API

resource "google_project_service" "gke" {
  project = "${module.application_project.project_id}"
  # Kubernetes Engine API
  service = "container.googleapis.com"
  # If true, services that are enabled and which depend on this service should also be disabled when this service is destroyed.
  disable_dependent_services = true
  disable_on_destroy = false
}
resource "google_project_service" "container_registry" {
  project = "${module.application_project.project_id}"
  service = "containerregistry.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}
resource "google_project_service" "container_analysis" {
  project = "${module.application_project.project_id}"
  service = "containeranalysis.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

resource "google_project_service" "cloudresourcemanager" {
  project = "${module.application_project.project_id}"
  service = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = false
}

# We need to enable this api to allow cloudbuild to decrypt secrets, even though
# the keys are created in another project.
resource "google_project_service" "kms-app-project" {
  project = "${module.application_project.project_id}"
  service = "cloudkms.googleapis.com"
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

### IAM
# Allow terraform to create GKE cluster, this is the highest gke privilege.
resource "google_project_iam_member" "container_admin" {
  project    = "${module.application_project.project_id}"
  # kubernetes engine api
  role       = "roles/container.admin"
  member     = "serviceAccount:${module.application_project.terraform_email}"
}

data "google_compute_default_service_account" "default" {
  project = "${module.application_project.project_id}"
  depends_on = ["google_project_service.gke"]
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

# Allow groups or users referenced in var.cloudbuild_editors to trigger cloud build pipelines.
