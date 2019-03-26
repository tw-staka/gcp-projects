output "project_id" {
  value = "${google_project.project.project_id}"
}

output "number" {
  value = "${google_project.project.number}"
}

output "terraform_email" {
  value = "${google_service_account.terraform.email}"
}