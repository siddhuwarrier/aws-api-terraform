resource "aws_security_group" "db_access_sg" {
  vpc_id      = var.aws_vpc_id
  name        = "${var.env}-db-access-sg"
  description = "Allow access to RDS"

  tags = {
    Name        = "${var.env}-db-access-sg"
    Environment = var.env
  }
}

resource "aws_security_group" "db_access_sg_replica" {
  vpc_id      = var.aws_replica_vpc_id
  provider    = aws.replica_region
  name        = "${var.env}-db-access-sg-replica"
  description = "Allow access to RDS (Replica)"

  tags = {
    Name        = "${var.env}-db-access-sg"
    Environment = var.env
    Type        = "Replica"
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

  //allow traffic for TCP 5432 from ECS and the Bastion Host
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.db_access_sg.id]
  }
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.db_bastion_sg_id]
  }

  // outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg_replica" {
  name        = "${var.env}-rds-sg-replica"
  description = "${var.env} Security Group (Replica)"
  provider    = aws.replica_region
  vpc_id      = var.aws_replica_vpc_id
  tags = {
    Name        = "${var.env}-rds-sg"
    Environment = var.env
    Type        = "Replica"
  }

  // allows traffic from the SG itself
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  //allow traffic for TCP 5432 from ECS and the Bastion Host
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.db_access_sg_replica.id]
  }

  // Not deploying a bastion host in replica region coz it costs me too much dosh :)
  # ingress {
  #   from_port       = 5432
  #   to_port         = 5432
  #   protocol        = "tcp"
  #   security_groups = [var.db_bastion_sg_id]
  # }

  // outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
