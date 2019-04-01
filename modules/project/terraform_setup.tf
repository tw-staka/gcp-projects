# This bucket is used to store the remote terraform state file
resource "google_storage_bucket" "terraform_remote_state" {
  name     = "${google_project.project.project_id}"
  project  = "${google_project.project.project_id}"
  # Use GCS Location https://cloud.google.com/storage/docs/bucket-locations
  location = "${var.terraform_state_bucket_location}"
  force_destroy = "true"

  versioning {
    enabled = true
  }
}
# This terraform service account is used to create resources ONLY.
resource "google_service_account" "terraform" {
  project  = "${google_project.project.project_id}"
  display_name = "terraform"
  account_id   = "terraform"
}

# https://www.terraform.io/docs/providers/google/r/storage_bucket_iam.html
# This policy DOES NOT removes all other default permissions on the bucket. The terraform state
# can store sensible information and should be locked down as much as possible.
resource "google_storage_bucket_iam_binding" "binding" {
  bucket = "${google_storage_bucket.terraform_remote_state.name}"
  role        = "roles/storage.objectAdmin"

  members = [
      # Allow terraform service account to read the state file/bucket.
      "serviceAccount:${google_service_account.terraform.email}",
      # You could add an SRE group or Security group for Break Glass Scenario
      # group:security@thoughtworks.com
    ]
}

# Allow developer to run terraform plan from their laptop. Helps to validate terraform code.
# Only the infrastructure pipeline can apply terraform code (and break the class scenario users if implemented)
# Be careful, if you store secrets in the state file, developer will have access to it.
# This could be featured toogle.
resource "google_storage_bucket_iam_member" "terraform_state_read_only" {
  count      = "${length(var.read_access_to_terraform_state_file)}"
  bucket     = "${google_storage_bucket.terraform_remote_state.name}"
  role       = "roles/storage.objectViewer"
  member     = "${var.read_access_to_terraform_state_file[count.index]}"
}
