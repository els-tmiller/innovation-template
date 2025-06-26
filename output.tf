output "environment_data" {
  value = module.environment.data
}

output "apache_endpoint" {
  value = "http://${aws_lb.lb.dns_name}"
}