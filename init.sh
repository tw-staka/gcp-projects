#!/usr/bin/env bash -e
export PROJECT_ID=staka-project-${RANDOM}
export TF_CREDS=~/.config/gcloud/${PROJECT_ID}.json

#Create Project
gcloud projects create ${PROJECT_ID} --folder=${TF_VAR_folder_id} --set-as-default

#Set Default Project
gcloud config set project ${PROJECT_ID}

#Link Billing Account
gcloud beta billing projects link ${PROJECT_ID} --billing-account ${TF_VAR_billing_account}

#Create Service Accounts
gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${PROJECT_ID}.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/viewer

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/storage.admin

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/container.admin

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/iam.serviceAccountAdmin

#Enable required services
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable container.googleapis.com

#Print Out Default Creds for CircleCI
echo "Created DEFAULT_APPLICATION_CREDENTIALS_FILE for CircleCI! \

DEFAULT_APPLICATION_CREDENTIALS_FILE= `cat ${TF_CREDS} | base64`"
