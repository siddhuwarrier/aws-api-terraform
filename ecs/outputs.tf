output "alb_hostname" {
  value = aws_alb.main.dns_name
}

output "microservice_dns" {
  value = aws_route53_record.deployment_dns.name
}
