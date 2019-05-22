# Thoughtworks organization
environment = "staging"
environment_short = "stg"
region = "australia-southeast1"
billing_account = "01AB68-2AED33-0CD57E"
# Can be a user, a service account, or a group
# See documentation here: https://www.terraform.io/docs/providers/google/r/google_project_iam.html
read_access_accounts = ["user:sethur@thoughtworks.com","user:johntan@thoughtworks.com", "user:sregupta@thoughtworks.com", "user:staka-folder-level-service-acc@stakafolderresources-237623.iam.gserviceaccount.com"]
read_access_to_terraform_state_file = ["user:sethur@thoughtworks.com","user:johntan@thoughtworks.com", "user:sregupta@thoughtworks.com", "user:sregupta@thoughtworks.com", "user:staka-folder-level-service-acc@stakafolderresources-237623.iam.gserviceaccount.com"]
