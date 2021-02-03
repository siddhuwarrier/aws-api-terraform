provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default" # you have to change this if you use a different profile
  region                  = var.aws_region
}

provider "aws" {
  alias  = "replica_region"
  region = var.aws_replica_region
}

module "vpc" {
  source             = "./vpc"
  env                = var.env
  aws_replica_region = var.aws_replica_region
}

module "rds" {
  source                     = "./rds"
  aws_region                 = var.aws_region
  aws_vpc_id                 = module.vpc.aws_vpc_id
  private_subnet_ids         = module.vpc.private_subnet_ids
  private_replica_subnet_ids = module.vpc.private_replica_subnet_ids
  database_name              = var.database_name
  database_username          = var.database_username
  database_password          = var.database_password
  db_bastion_sg_id           = module.vpc.db_bastion_sg_id
  env                        = var.env
  aws_replica_region         = var.aws_replica_region
}

module "ec2" {
  source              = "./ec2"
  db_bastion_sg_id    = module.vpc.db_bastion_sg_id
  env                 = var.env
  public_subnet_ids   = module.vpc.public_subnet_ids
  bastion_host_pubkey = var.bastion_host_pubkey
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
  env                = var.env
  hosted_zone_dns    = var.hosted_zone_dns
  hosted_zone_id     = var.hosted_zone_id
}

module "swagger" {
  source          = "./swagger"
  hosted_zone_id  = var.hosted_zone_id
  hosted_zone_dns = var.hosted_zone_dns
  aws_region      = var.aws_region
  env             = var.env
}
