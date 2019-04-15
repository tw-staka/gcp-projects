# A google project-id is unique and cannot be re-used which is why we append
# a unique id to its project id to avoid errors when recreating it
resource "random_id" "project_suffix" {
  byte_length = 3
}

# https://www.terraform.io/docs/providers/google/r/google_project.html
resource "google_project" "project" {
  name                = "${var.project_name}-${var.environment_short}"
  project_id          = "${var.project_name}-${var.environment_short}-${random_id.project_suffix.hex}"
  # Projects created with this resource must be associated with an Organization or a folder
  billing_account = "${var.billing_account}"
  # Uncomment the line below if you are creating projects in a folder.
  folder_id = "${var.folder_id}"
  auto_create_network = true

  labels = {
    environment       = "${var.environment}"
    environment_short = "${var.environment_short}"
  }
}

resource "google_project_iam_member" "project_viewer" {
  count         = "${length(var.read_access_accounts)}"
  project    = "${google_project.project.project_id}"
  role       = "roles/viewer"
  member     = "${var.read_access_accounts[count.index]}"
}
