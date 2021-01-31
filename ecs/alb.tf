resource "aws_alb" "main" {
  name            = "${var.env}-aws-api-load-balancer"
  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.alb_sg.id]

  tags = {
    Name        = "${var.env}-aws-api-load-balancer"
    Environment = var.env
  }
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
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-2:686080651210:certificate/cf25dc43-2f71-416d-8966-43580d4a0a34"

  default_action {
    target_group_arn = aws_alb_target_group.microservice_target_group.id
    type             = "forward"
  }
}

resource "aws_route53_record" "deployment_dns" {
  zone_id = var.hosted_zone_id
  name    = "${var.env}.${var.hosted_zone_dns}"
  type    = "A"
  alias {
    name                   = aws_alb.main.dns_name
    zone_id                = aws_alb.main.zone_id
    evaluate_target_health = true
  }
}
