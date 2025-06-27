output "apache_endpoint" {
  value = "https://${aws_route53_record.alb_alias.fqdn}"
}