resource "aws_key_pair" "staging_bastion_key" {
  key_name   = "staging-bastion-key"
  public_key = var.bastion_host_pubkey
}

resource "aws_instance" "db_bastion" {
  ami                         = var.bastion_ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "staging-bastion-key"
  vpc_security_group_ids      = [var.db_bastion_sg_id]
  subnet_id                   = element(var.public_subnet_ids, 0)
  tags = {
    Name        = "${var.env}-db-bastion"
    Environment = var.env
  }
}
