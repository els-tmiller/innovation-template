output "apache_endpoint" {
  value = "http://${aws_lb.lb.dns_name}"
}