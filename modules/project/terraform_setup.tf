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
# is sensible information and should be locked down as much as possible.
resource "google_storage_bucket_iam_binding" "binding" {
  bucket = "${google_storage_bucket.terraform_remote_state.name}"
  role        = "roles/storage.objectAdmin"

  members = [
      # Allow terraform service account to read the state file.
      "serviceAccount:${google_service_account.terraform.email}",
      #DEBUG only
      "user:pvalla@thoughtworks.com"
      # You should add an SRE group or Security group for Break Glass Scenario
      # group:security@thoughtworks.com
    ]
}

# Here we setup what this terraform can do
# THE page you will spend a lot of time on:
# https://cloud.google.com/iam/docs/understanding-roles
resource "google_project_iam_binding" "project_iam_admin" {
  project    = "${google_project.project.project_id}"
  # This is a very powerful role, right now, cloudbuild could make itself Project Owner.
  # You should setup CODEOWNER feature on github to restrict futher down who can edit IAM permission
  # Or setup Iam rules in Layer1 (when creating the project and enabling apis)
  role       = "roles/resourcemanager.projectIamAdmin"
  members     = [
    "serviceAccount:${google_service_account.terraform.email}"
  ]
}
