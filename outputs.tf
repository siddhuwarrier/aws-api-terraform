output "alb_hostname" {
  value = module.ecs.alb_hostname
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "aws_vpc_id" {
  value = module.vpc.aws_vpc_id
}
