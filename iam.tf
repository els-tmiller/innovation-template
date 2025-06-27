
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_execution" {
  name = "${local.resource_name_prefix}-ecs-execution"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "ecs_task" {
  name = "${local.resource_name_prefix}-ecs-task"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "ecs_execution" {
  name = "${local.resource_name_prefix}-ecs-execution"
  role = aws_iam_role.ecs_execution.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_cloudwatch_log_group.logs.arn}:log-stream:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_task" {
  name = "${local.resource_name_prefix}-ecs-task"
  role = aws_iam_role.ecs_task.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.website_files.arn}",
          "${aws_s3_bucket.website_files.arn}/*"
        ]
      },
      {
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
        ]
        Effect = "Allow"
        Resource = [
          "*",
        ]
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_cloudwatch_log_group.logs.arn}:log-stream:*"
        ]
      }
    ]
  })
}
