variable "aws_region" {}
variable "aws_vpc_id" {}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "microserviceTaskExecutionRole"
}

variable "ecs_task_role_name" {
  description = "ECS task role name"
  default     = "microserviceTaskRole"
}

variable "microservice_img" {
  description = "Docker image to run in the ECS cluster"
  default     = "686080651210.dkr.ecr.eu-west-2.amazonaws.com/siddhuw.info:latest"
}

variable "microservice_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}

variable "microservice_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "health_check_path" {
  default = "/health"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Subnet ids"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Subnet ids"
}

variable "db_access_sg_id" {
  description = "ID of security group that has access to the RDS instance"
}

variable "env" {
}

variable "db_endpoint" {
}

variable "database_name" {
}

variable "database_username" {
}

variable "database_password" {
}

variable "log_retention_days" {
  description = "Number of days to keep Cloudwatch logs"
  default     = "5"
}

variable "hosted_zone_id" {}

variable "hosted_zone_dns" {}
