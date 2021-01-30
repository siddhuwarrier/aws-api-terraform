resource "aws_ecs_cluster" "main" {
  name = "aws-api-cluster"
}

data "template_file" "aws_api_microservice_tpl" {
  template = file("./ecs/templates/aws_api_microservice.json.tpl")

  vars = {
    microservice_img  = var.microservice_img
    microservice_port = var.microservice_port
    fargate_cpu       = var.fargate_cpu
    fargate_memory    = var.fargate_memory
    aws_region        = var.aws_region
  }
}

resource "aws_ecs_task_definition" "microservice" {
  family                   = "aws-api-microservice-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.aws_api_microservice_tpl.rendered
}

resource "aws_ecs_service" "main" {
  name            = "aws-api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.microservice.arn
  desired_count   = var.microservice_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = var.private_subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.microservice_target_group.id
    container_name   = "aws-api-microservice"
    container_port   = var.microservice_port
  }

  depends_on = [aws_alb_listener.microservice_listener, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
