provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default" # you have to change this if you use a different profile
  region                  = var.aws_region
}

module "vpc" {
  source = "./vpc"
}

module "rds" {
  source             = "./rds"
  aws_region         = var.aws_region
  aws_vpc_id         = module.vpc.aws_vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  database_name      = var.database_name
  database_username  = var.database_username
  database_password  = var.database_password
}

module "ecs" {
  source = "./ecs"

  aws_region         = var.aws_region
  aws_vpc_id         = module.vpc.aws_vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  database_name      = var.database_name
  database_username  = var.database_username
  database_password  = var.database_password
  db_access_sg_id    = module.rds.db_access_sg_id
  db_endpoint        = module.rds.db_endpoint
}
