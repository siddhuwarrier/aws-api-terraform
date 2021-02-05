variable "aws_region" {}
variable "aws_replica_region" {}
variable "aws_vpc_id" {}
variable "aws_replica_vpc_id" {}

variable "env" {
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Subnet ids"
}

variable "private_replica_subnet_ids" {
  type        = list(string)
  description = "Subnet ids"
}

variable "instance_class" {
  description = "The Instance class to use for the RDS cluster. Leave it at t2.micro if you do not want to spend £££."
  default     = "db.t2.micro"
}

variable "database_name" {
}

variable "database_username" {
}

variable "database_password" {
}

variable "allocated_storage" {
  default     = "20"
  description = "The storage size in GiB"
}

variable "db_bastion_sg_id" {
}
