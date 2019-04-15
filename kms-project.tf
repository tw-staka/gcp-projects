# PROJECT CREATION
module "project" {
    source = "./modules/project"
    project_name = "kms-project"
    environment = "${var.environment}"
    environment_short = "${var.environment_short}"
    billing_account = "${var.billing_account}"
    read_access_accounts = "${var.read_access_accounts}"
    folder_id = "${var.folder_id}"
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
  member     = "serviceAccount:${module.project.terraform_email}"
}



### KMS
resource "google_kms_key_ring" "developer_keyring" {
  name     = "developer-keyring"
  project = "${module.project.project_id}"
  location = "${var.region}"

  depends_on = ["google_project_service.kms"]
}

resource "google_kms_crypto_key" "secret_key" {
  name = "secret-key"
  key_ring = "${google_kms_key_ring.developer_keyring.self_link}"

  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = true
  }
}

# Developers can encrypt ONLY
resource "google_kms_key_ring_iam_member" "developer_encryption" {
  key_ring_id = "${google_kms_key_ring.developer_keyring.self_link}"
  role        = "roles/cloudkms.cryptoKeyEncrypter"

  // Needs to be changed to a developer group ie: group:app_developer@company.com
  member      = "user:sandhu@thoughtworks.com"
}

# Cloud Build can Decrypt secrets encrypted by developers.
resource "google_kms_key_ring_iam_member" "cloudbuild_decryption" {
  key_ring_id = "${google_kms_key_ring.developer_keyring.self_link}"
  role        = "roles/cloudkms.cryptoKeyDecrypter"
  member    = "serviceAccount:${module.application_project.number}@cloudbuild.gserviceaccount.com"
}
