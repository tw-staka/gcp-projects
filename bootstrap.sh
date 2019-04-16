#!/usr/bin/env bash

## this is not finished yet
set -euo pipefail
folderId=$1
projectId=$2
organizationId=$3

login() {
    gcloud auth login
}

createProject() {
    gcloud projects create ${projectId} \
        --folder=${folderId} \
        --organization=${organizationId} \
}

login
createProject

