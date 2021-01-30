output "db_access_sg_id" {
  value = aws_security_group.db_access_sg.id
}

output "db_endpoint" {
  value = aws_db_instance.aws_api_db_rds.endpoint
}
