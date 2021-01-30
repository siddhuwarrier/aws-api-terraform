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
}
