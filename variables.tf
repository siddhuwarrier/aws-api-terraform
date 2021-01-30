variable "aws_region" {
  description = "AWS region to use"
  default     = "eu-west-2"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "microserviceTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
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
