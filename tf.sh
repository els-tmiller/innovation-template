#!/bin/sh

# This script is used by CodeBuild to run Terraform for innovation patterns.
# It may also be used locally for testing/development purposes, by setting the required environment variables.

# Verify Terraform version matches that specified in .terraform_version
TARGET_TF_VERSION=$(cat .terraform_version)
TERRAFORM_VERSION=$(terraform version | grep 'Terraform v' | awk '{print $2}' | sed 's/v//')

if [ -z "$TERRAFORM_VERSION" ]; then
  echo "\nTerraform is not installed or not found in PATH.\n"
  exit 1
elif [ "$TERRAFORM_VERSION" != "$TARGET_TF_VERSION" ]; then
  echo "\nTerraform version mismatch: expected $TARGET_TF_VERSION, but found $TERRAFORM_VERSION."
  echo "Please install the correct version of Terraform.\n"
  exit 1
else
    echo "\nUsing Terraform version: $TERRAFORM_VERSION\n"
fi

# Verify required environment variables are set 
if [ -z "$ENVIRONMENT_NAME" ]; then
  echo "ENVIRONMENT_NAME is not set.\n"
  exit 1
elif [ -z "$S3_BACKEND_BUCKET" ]; then
  echo "S3_BACKEND_BUCKET is not set or is empty.\n"
  exit 1
elif [ -z "$S3_BACKEND_KEY" ]; then
  echo "S3_BACKEND_KEY is not set or is empty.\n"
  exit 1
elif [ -z "$S3_BACKEND_REGION" ]; then
  echo "S3_BACKEND_REGION is not set or is empty.\n"
  exit 1
elif [ -z "$TARGET_REGION" ]; then
  echo "TARGET_REGION is not set or is empty.\n"
  exit 1
else
  echo "All required environment variables are set.\n"
fi

# Set the TF varibles required for innovation patterns
TF_VARIABLES="-var aws_region=${TARGET_REGION} -var environment_name=${ENVIRONMENT_NAME}"


if [ "$#" -ne 0 ]; then
  TERRAFORM_COMMAND="$@"
elif [ -z "$TERRAFORM_COMMAND" ]; then
  echo "No terraform command was provided.\n"
  exit 1
fi

case "$TERRAFORM_COMMAND" in
  apply* | plan* | destroy*)
    TERRAFORM_COMMAND="${TERRAFORM_COMMAND} ${TF_VARIABLES}"
    ;;
esac

echo "Terraform Action: $TERRAFORM_COMMAND\n"

echo "Initializing Terraform with the following backend configuration:"
echo "\tS3_BACKEND_BUCKET: ${S3_BACKEND_BUCKET}"
echo "\tS3_BACKEND_KEY: ${S3_BACKEND_KEY}"
echo "\tS3_BACKEND_REGION: ${S3_BACKEND_REGION}"
echo "\tTARGET_REGION: ${TARGET_REGION}\n"

echo "\nRunning command: terraform init --backend-config=bucket=${S3_BACKEND_BUCKET} --backend-config=key=${S3_BACKEND_KEY} --backend-config=region=${S3_BACKEND_REGION}\n"

terraform init \
  -backend-config=bucket=${S3_BACKEND_BUCKET} \
  -backend-config=key=${S3_BACKEND_KEY} \
  -backend-config=region=${S3_BACKEND_REGION}

echo "\nRunning command: terraform $TERRAFORM_COMMAND\n"

terraform ${TERRAFORM_COMMAND}