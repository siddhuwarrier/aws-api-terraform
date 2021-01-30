variable "aws_region" {
  description = "AWS region to use"
  default     = "eu-west-2"
}

variable "database_username" {
  default     = "postgres"
  description = "The default postgres username"
}

variable "database_password" {
  description = "The Postgres password"
}

variable "database_name" {
  default     = "awsapidb"
  description = "The database name (defaults to aws-api-db)"
}
