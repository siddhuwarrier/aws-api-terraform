resource "aws_security_group" "db_access_sg" {
  vpc_id      = var.aws_vpc_id
  name        = "${var.env}-db-access-sg"
  description = "Allow access to RDS"

  tags = {
    Name        = "${var.env}-db-access-sg"
    Environment = var.env
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.env}-rds-sg"
  description = "${var.env} Security Group"
  vpc_id      = var.aws_vpc_id
  tags = {
    Name        = "${var.env}-rds-sg"
    Environment = var.env
  }

  // allows traffic from the SG itself
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  //allow traffic for TCP 5432
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.db_access_sg.id]
  }

  // outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
