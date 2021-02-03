# Postgres RDS cluster
resource "aws_db_instance" "aws_api_db_rds" {
  identifier             = "${var.env}-database"
  allocated_storage      = var.allocated_storage
  engine                 = "postgres"
  instance_class         = var.instance_class
  multi_az               = false
  name                   = var.database_name
  username               = var.database_username
  password               = var.database_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  tags = {
    Environment = var.env
  }
  backup_retention_period = 1

  apply_immediately = true
}

# Read Replica
resource "aws_db_instance" "aws_api_db_rds_replica" {
  provider               = aws.replica_region
  replicate_source_db    = aws_db_instance.aws_api_db_rds.arn
  identifier             = "${var.env}-database-read-replica"
  allocated_storage      = var.allocated_storage
  engine                 = "postgres"
  instance_class         = var.instance_class
  multi_az               = false
  name                   = "${var.database_name}-read-replica"
  username               = var.database_username
  password               = var.database_password
  db_subnet_group_name   = aws_db_subnet_group.rds_replica_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg_replica.id]
  skip_final_snapshot    = true
  tags = {
    Environment = var.env
    Type        = "Read Replica"
  }

  apply_immediately = true
}
