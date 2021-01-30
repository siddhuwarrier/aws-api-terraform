output "db_bastion_public_ip" {
  value = aws_instance.db_bastion.public_ip
}
