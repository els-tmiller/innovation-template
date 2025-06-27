resource "aws_ecs_cluster" "ecs" {
  name = local.resource_name_prefix
}

resource "aws_ecs_task_definition" "apache" {
  family                   = "apache"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  volume {
    name = "website"
  }

  container_definitions = jsonencode([
    {
      name  = "init-container"
      image = "public.ecr.aws/aws-cli/aws-cli:latest"
      mountPoints = [
        {
          sourceVolume  = "website"
          containerPath = "/website"
        }
      ]
      entryPoint = [
        "sh",
        "-c"
      ]
      command = [
        "aws s3 sync s3://${aws_s3_bucket.website_files.id}/ /website"
      ],
      essential = false

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.logs.name
          awslogs-region        = module.environment.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      name = "apache"
      dependsOn = [
        {
          containerName = "init-container",
          condition     = "COMPLETE"
        }
      ],
      image     = "public.ecr.aws/docker/library/httpd:latest"
      essential = true
      mountPoints = [
        {
          sourceVolume  = "website"
          containerPath = "/usr/local/apache2/htdocs"
        }
      ]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.logs.name
          awslogs-region        = module.environment.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "apache" {
  name            = "apache"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.apache.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.environment.data.public_subnets
    security_groups  = [aws_security_group.apache.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.apache.arn
    container_name   = "apache"
    container_port   = 80
  }

  depends_on = [aws_security_group.apache]
}