output "apache_endpoint" {
  value = "https://${aws_lb.lb.dns_name}"
}