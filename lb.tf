resource "aws_lb" "lb" {
  name               = "${var.environment_name}-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = module.environment.data.public_subnets
}

resource "aws_lb_target_group" "apache" {
  name        = "${var.environment_name}-apache-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.environment.data.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = module.environment.data.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apache.arn
  }
}