resource "aws_route53_record" "alb_alias" {
  zone_id = module.environment.data.dns_zone_id
  name    = var.environment_name
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}