resource "aws_ecs_cluster" "ecs" {
  name = "demo"
}

resource "aws_ecs_task_definition" "apache" {
  family                   = "apache"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "apache"
      image     = "public.ecr.aws/docker/library/httpd:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
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