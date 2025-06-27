locals {
  resource_name_prefix = "innovation-pattern-${var.environment_name}"

  tags = {
    "Description" = "Terraform module for deploying an Apache web server."
  }
}