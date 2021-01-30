/* subnet used by rds */
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.env}-rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = var.private_subnet_ids
  tags = {
    Environment = var.env
  }
}
