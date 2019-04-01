# tw-in-a-box-gcp-projects
This Terraform repo contains configuration to create projects in GCP.

## Prerequisite
1. GCP bucket to store the Terraform state file, this bucket needs to be accessible from the identity running Terraform.
1. Service account key with project creation permission, in a folder in your organisation. If you can't create a folder, export your google cloud credentials:

 This is a workaround for when you are unable to create service accounts tied to a folder, with project creator role.
 This is not the preferred method.

  ```bash
  # Here we will save our application-default credentials to gcloud config
  $ gcloud auth application-default login
  # This will print your application-default credentials in a base64 encoded format to use in CircleCI
  $ cat ~/.config/gcloud/application_default_credentials.json | base64
  ```
Import the application-default credentials into CircleCI under the following environment variable: `DEFAULT_APPLICATION_CREDENTIALS_FILE`

This environment variable will be decoded and populate a file to be used by Terraform.
 [See here](./.circleci/config.yml)

 1. Link this repository to CircleCI.

 ## Installation

This Terraform configuration is run by CircleCi. It creates two projects:
- application-project:
  This projects is used to build, scan and deploy docker containers onto Google Kubernetes Engine (GKE)
  APIs
  - GKE
  - Google Container Registry (docker registry)
  - Google Container Analysis (Scanning images for known vulnerabilities)
  - Google Cloud Build (Build and deploy Docker images)
  - Google Cloud Source Repositories (To mirror the github repository)
  - Google Cloud Key Management Service

- KMS:
  This projects contains a Key used for encrypting secrets by developer and to allow cloud build in the application project to decrypt those secrets.

For each project, via the project module, has a:
- Terraform Service Account with least privilege to create resources in it's own project.
- Google Cloud Storage bucket, used to hold Terraform state.