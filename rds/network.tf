/* subnet used by rds */
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.env}-rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = var.private_subnet_ids
  tags = {
    Environment = var.env
  }
}

/* subnet used by rds replica */
resource "aws_db_subnet_group" "rds_replica_subnet_group" {
  name        = "${var.env}-rds-replica-subnet-group"
  provider    = aws.replica_region
  description = "RDS subnet group"
  subnet_ids  = var.private_replica_subnet_ids
  tags = {
    Environment = var.env
    Type        = "Replica"
  }
}
