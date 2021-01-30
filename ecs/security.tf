resource "aws_security_group" "alb_sg" {
  name        = "${var.env}-aws-api-load-balancer-security-group"
  description = "ALB Security Group"
  vpc_id      = var.aws_vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.microservice_port
    to_port     = var.microservice_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.env}-aws-api-load-balancer-security-group"
    Environment = var.env
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.env}-aws-api-ecs-tasks-security-group"
  description = "allow inbound access to ECS tasks from the ALB only"
  vpc_id      = var.aws_vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.microservice_port
    to_port         = var.microservice_port
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.env}-aws-api-ecs-tasks-security-group"
    Environment = var.env
  }
}
