resource "aws_security_group" "db_bastion_sg" {
  name        = "${var.env}-db-bastion-sg"
  description = "${var.env} Bastion Security Group to spin up a Bastion host that can access RDS"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name        = "${var.env}-db-bastion-sg"
    Environment = var.env
  }

  // allows SSH traffic globally
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
