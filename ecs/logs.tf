resource "aws_cloudwatch_log_group" "microservice_log_group" {
  name              = "/ecs/${var.env}-aws-api-microservice"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "aws-api-microservice-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "microservice_log_stream" {
  name           = "microservice-log-stream"
  log_group_name = aws_cloudwatch_log_group.microservice_log_group.name
}
