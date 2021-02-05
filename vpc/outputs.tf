output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "db_bastion_sg_id" {
  value = aws_security_group.db_bastion_sg.id
}

output "aws_replica_vpc_id" {
  value = aws_vpc.main_replica.id
}

output "public_replica_subnet_ids" {
  value = aws_subnet.public_replica.*.id
}

output "private_replica_subnet_ids" {
  value = aws_subnet.private_replica.*.id
}
