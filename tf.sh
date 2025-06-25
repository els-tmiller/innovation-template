#!/bin/sh

TARGET_TF_VERSION=$(cat .terraform_version)
TERRAFORM_VERSION=$(terraform version -json | jq -r '.terraform_version')

if [ -z "$TERRAFORM_VERSION" ]; then
    echo -e "\nTerraform is not installed or not found in PATH."
    exit 1
elif
  [ "$TERRAFORM_VERSION" != "$TARGET_TF_VERSION" ]; then
    echo -e "\nTerraform version mismatch: expected $TARGET_TF_VERSION, but found $TERRAFORM_VERSION."
    echo -e "Please install the correct version of Terraform.\n"
    exit 1
else
    echo -e "\nUsing Terraform version: $TERRAFORM_VERSION\n"
fi

if [ "$#" -ne 0 ]; then
  TERRAFORM_COMMAND="$@"
  echo -e "Using custom Terraform command: $TERRAFORM_COMMAND\n"
elif [ -z "$TERRAFORM_COMMAND" ]; then
  echo -e "TERRAFORM_COMMAND is not set.\n"
  exit 1
else
  echo -e "Running Terraform command: $TERRAFORM_COMMAND\n"
fi

if [ -z "$S3_BACKEND_BUCKET" ]; then
    echo "S3_BACKEND_BUCKET is not set or is empty."
    exit 1
elif [ -z "$S3_BACKEND_KEY" ]; then
    echo "S3_BACKEND_KEY is not set or is empty."
    exit 1
elif [ -z "$S3_BACKEND_REGION" ]; then
    echo "S3_BACKEND_REGION is not set or is empty."
    exit 1
else
    echo -e "All required environment variables are set.\n"
fi


echo -e "Initializing Terraform with the following backend configuration:\n"
echo -e "\tS3_BACKEND_BUCKET: ${S3_BACKEND_BUCKET}"
echo -e "\tS3_BACKEND_KEY: ${S3_BACKEND_KEY}"
echo -e "\tS3_BACKEND_REGION: ${S3_BACKEND_REGION}\n"

terraform init \
  -backend-config=bucket=${S3_BACKEND_BUCKET} \
  -backend-config=key=${S3_BACKEND_KEY} \
  -backend-config=region=${S3_BACKEND_REGION}

terraform $TERRAFORM_COMMAND