# Thoughtworks organization
org_id = "730381449093"
environment = "staging"
environment_short = "stg"
region = "australia-southeast1"
billing_account = "01AA23-AF169C-E8EFE5"
# Can be a user, a service account, or a group
# See documentation here: https://www.terraform.io/docs/providers/google/r/google_project_iam.html
read_access_accounts = ["user:sandhu@thoughtworks.com","user:willvk@thoughtworks.com"]
read_access_to_terraform_state_file = ["user:sandhu@thoughtworks.com"]
cloudbuild_editors = ["user:sandhu@thoughtworks.com"]
