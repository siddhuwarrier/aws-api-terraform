resource "aws_alb" "main" {
  name            = "aws-api-load-balancer"
  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.alb_sg.id]
}

# TODO switch to HTTPS and 443 with ACM
resource "aws_alb_target_group" "microservice_target_group" {
  name        = "aws-api-alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "microservice_listener" {
  load_balancer_arn = aws_alb.main.id
  port              = var.microservice_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.microservice_target_group.id
    type             = "forward"
  }
}
