resource "aws_cloudwatch_log_group" "logs" {
  name              = local.resource_name_prefix
  retention_in_days = 7

  tags = local.tags
}