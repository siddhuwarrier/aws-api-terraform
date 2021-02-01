output "microservice_dns" {
  value = module.ecs.microservice_dns
}

output "swagger_ui_dns" {
  value = module.swagger.swagger_ui_dns
}

output "alb_hostname" {
  value = module.ecs.alb_hostname
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "aws_vpc_id" {
  value = module.vpc.aws_vpc_id
}

output "db_bastion_public_ip" {
  value = module.ec2.db_bastion_public_ip
}
