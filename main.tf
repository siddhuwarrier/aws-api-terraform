provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default" # you have to change this if you use a different profile
  region                  = var.aws_region
}

module "vpc" {
  source = "./vpc"
}

module "ecs" {
  source = "./ecs"

  aws_region         = var.aws_region
  aws_vpc_id         = module.vpc.aws_vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}
