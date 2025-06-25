output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "region" {
  value = data.aws_region.current.name
}

output "vpc_id" {
  value = local.vpc_id
}

output "cidr_block" {
  value = local.cidr_block
}

output "public_subnets" {
  value = local.subnets.public
}

output "private_subnets" {
  value = local.subnets.private
}

output "data" {
  value = {
    account_id      = data.aws_caller_identity.current.account_id
    cidr_block      = local.cidr_block
    private_subnets = local.subnets.private
    public_subnets  = local.subnets.public
    region          = data.aws_region.current.name
    vpc_id          = local.vpc_id
  }
}