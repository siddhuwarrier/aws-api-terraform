provider "aws" {
  alias  = "replica_region"
  region = var.aws_replica_region
}
