terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }
  }

  required_version = "~> 1.8"
}

provider "aws" {
  region = var.aws_region

  #allowed_account_ids = [var.aws_config.account_id]

  default_tags {
    tags = { "CreatedBy" = "Innovation CodeBuild" }
  }
}
