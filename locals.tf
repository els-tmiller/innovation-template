locals {
  resource_name_prefix = "innov-${var.environment_name}"

  tags = {
    "Description" = "Terraform module for deploying an Apache web server."
  }
}