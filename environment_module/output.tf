output "acm_certificate_arn" {
  value = data.aws_acm_certificate.dce.arn
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "dns_zone_id" {
  value = data.aws_route53_zone.dce.id
}

output "domain_name" {
  value = data.aws_acm_certificate.dce.domain
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
    acm_certificate_arn = data.aws_acm_certificate.dce.arn
    account_id          = data.aws_caller_identity.current.account_id
    cidr_block          = local.cidr_block
    dns_zone_id         = data.aws_route53_zone.dce.id
    domain_name         = data.aws_acm_certificate.dce.domain
    private_subnets     = local.subnets.private
    public_subnets      = local.subnets.public
    region              = data.aws_region.current.name
    vpc_id              = local.vpc_id
  }
}