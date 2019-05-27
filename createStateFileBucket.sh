#!/bin/sh

set -euo pipefail

GCP_REGION=$2
STATE_BUCKET_NAME=$3

function main {
    if ! stateBucketExists; then
        createStateBucket
    fi
}

function stateBucketExists {
    gsutil ls -b "gs://${STATE_BUCKET_NAME}" >/dev/null 2>&1
}

function createStateBucket {
    gsutil mb -c regional -p ${PROJECT_ID} -l ${GCP_REGION} "gs://${STATE_BUCKET_NAME}"
}

main
