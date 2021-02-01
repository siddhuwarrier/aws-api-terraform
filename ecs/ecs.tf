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
    env               = var.env
    db_endpoint       = var.db_endpoint
    db_name           = var.database_name
    db_password       = var.database_password
    db_username       = var.database_username
  }
}

resource "aws_ecs_task_definition" "microservice" {
  family                   = "${var.env}-aws-api-microservice-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.aws_api_microservice_tpl.rendered
}

resource "aws_ecs_service" "main" {
  name                               = "${var.env}-aws-api-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.microservice.arn
  desired_count                      = var.microservice_count
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 250

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id, var.db_access_sg_id]
    subnets          = var.private_subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.microservice_target_group.id
    container_name   = "${var.env}-aws-api-microservice"
    container_port   = var.microservice_port
  }

  depends_on = [aws_alb_listener.microservice_listener, aws_iam_role_policy_attachment.ecs_task_execution_role_attachment, aws_iam_role_policy_attachment.ecs_task_role_ec2_attachment]
}
