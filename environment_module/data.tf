data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpcs" "innovation" {
  tags = {
    Name = "innovation"
  }
}

data "aws_vpc" "innovation" {
  for_each = toset(data.aws_vpcs.innovation.ids)

  filter {
    name   = "vpc-id"
    values = [each.value]
  }
}

data "aws_subnets" "public" {
  for_each = toset(data.aws_vpcs.innovation.ids)

  filter {
    name   = "vpc-id"
    values = [each.value]
  }

  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

data "aws_subnets" "private" {
  for_each = toset(data.aws_vpcs.innovation.ids)

  filter {
    name   = "vpc-id"
    values = [each.value]
  }

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}