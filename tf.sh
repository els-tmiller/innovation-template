#!/bin/sh

TARGET_TF_VERSION=$(cat .terraform_version)
TERRAFORM_VERSION=$(terraform version | grep 'Terraform v' | awk '{print $2}' | sed 's/v//')

if [ -z "$TERRAFORM_VERSION" ]; then
    echo "\nTerraform is not installed or not found in PATH."
    exit 1
elif
  [ "$TERRAFORM_VERSION" != "$TARGET_TF_VERSION" ]; then
    echo "\nTerraform version mismatch: expected $TARGET_TF_VERSION, but found $TERRAFORM_VERSION."
    echo "Please install the correct version of Terraform.\n"
    exit 1
else
    echo "\nUsing Terraform version: $TERRAFORM_VERSION\n"
fi

if [ "$#" -ne 0 ]; then
  TERRAFORM_COMMAND="$@"
  echo "Using custom Terraform command: $TERRAFORM_COMMAND\n"
elif [ -z "$TERRAFORM_COMMAND" ]; then
  echo "TERRAFORM_COMMAND is not set.\n"
  exit 1
fi

if [ -z "$ENVIRONMENT_NAME" ]; then
  echo "ENVIRONMENT_NAME is not set."
  exit 1
fi

TF_VARIABLES="-var aws_region=${TARGET_REGION} -var environment_name=${ENVIRONMENT_NAME}"

if [[ "$TERRAFORM_COMMAND" == "apply"* ]]; then
  TERRAFORM_COMMAND="${TERRAFORM_COMMAND} ${TF_VARIABLES}"
elif [[ "$TERRAFORM_COMMAND" == "plan"* ]]; then
  TERRAFORM_COMMAND="${TERRAFORM_COMMAND} ${TF_VARIABLES}"
fi

echo "Running Terraform command: $TERRAFORM_COMMAND\n"

if [ -z "$S3_BACKEND_BUCKET" ]; then
    echo "S3_BACKEND_BUCKET is not set or is empty."
    exit 1
elif [ -z "$S3_BACKEND_KEY" ]; then
    echo "S3_BACKEND_KEY is not set or is empty."
    exit 1
elif [ -z "$S3_BACKEND_REGION" ]; then
    echo "S3_BACKEND_REGION is not set or is empty."
    exit 1
elif [ -z "$TARGET_REGION" ]; then
    echo "TARGET_REGION is not set or is empty."
    exit 1
else
    echo "All required environment variables are set."
fi

echo "Initializing Terraform with the following backend configuration:\n"
echo "\tS3_BACKEND_BUCKET: ${S3_BACKEND_BUCKET}"
echo "\tS3_BACKEND_KEY: ${S3_BACKEND_KEY}"
echo "\tS3_BACKEND_REGION: ${S3_BACKEND_REGION}\n"
echo "\tTARGET_REGION: ${TARGET_REGION}\n"

terraform init \
  -backend-config=bucket=${S3_BACKEND_BUCKET} \
  -backend-config=key=${S3_BACKEND_KEY} \
  -backend-config=region=${S3_BACKEND_REGION}

terraform ${TERRAFORM_COMMAND}