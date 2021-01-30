provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default" # you have to change this if you use a different profile
  region                  = var.aws_region
}
