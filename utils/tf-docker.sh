#!/bin/sh

docker build . -t innovation-development

if [ ! -e ".temporary_credentials" ]; then
  go-aws-sso --persist
  awk '/\[default\]/,/^$/' ~/.aws/credentials > .temporary_credentials
fi

TERRAFORM_COMMAND="$@"

docker run -it --rm \
  -e S3_BACKEND_BUCKET=$S3_BACKEND_BUCKET \
  -e S3_BACKEND_KEY=$S3_BACKEND_KEY \
  -e S3_BACKEND_REGION=$S3_BACKEND_REGION \
  -e ENVIRONMENT_NAME=$ENVIRONMENT_NAME \
  -e TARGET_REGION=$TARGET_REGION \
  -e DOWNLOAD_MODULES=false \
  -v ${PWD}/.temporary_credentials:/root/.aws/credentials:ro \
  innovation-development $TERRAFORM_COMMAND