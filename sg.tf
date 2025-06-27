resource "aws_security_group" "lb" {
  name        = "${local.resource_name_prefix}-lb-sg"
  description = "Security group for Load Balancer"
  vpc_id      = module.environment.data.vpc_id
}

resource "aws_security_group_rule" "lb_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.lb.id
  description       = "Allow HTTP traffic from the internet to Load Balancer"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
}

resource "aws_security_group_rule" "lb_egress" {
  type                     = "egress"
  security_group_id        = aws_security_group.lb.id
  description              = "Allow all outbound traffic from Load Balancer"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.apache.id
}

resource "aws_security_group" "apache" {
  name        = "${var.environment_name}-apache-sg"
  description = "Security group for ECS tasks"
  vpc_id      = module.environment.data.vpc_id
}

resource "aws_security_group_rule" "apache_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.apache.id
  description              = "Allow HTTP traffic from Load Balancer to Apache tasks"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "apache_egress" {
  type              = "egress"
  security_group_id = aws_security_group.apache.id
  description       = "Allow all outbound traffic from Apache tasks"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}