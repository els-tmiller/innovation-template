### This file contains the minimum code required for compatibility with the Innovation CodeBuild environment.
#   It is highly recommended that you do not modify this file.

terraform {
  backend "s3" {}
  required_version = "~> 1.8"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = { 
      "CreatedBy"   = "Innovation CodeBuild" 
      "Environment" = var.environment_name
    }
  }
}

variable "aws_region" {
  description = "AWS Region"
}

variable "environment_name" {
  description = "Environment name"
  type        = string
}

module "environment" {
  source = "./environment_module"
}

output "environment_data" {
  value = module.environment.data
}