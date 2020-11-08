output "registry" {
  value = aws_ecr_repository.pablow_registry.repository_url
}

output "bastion-host" {
  value = aws_eip.bastion_host.public_ip
}

output "dev-load-balancer" {
  value = aws_lb.development.dns_name
}

output "stg-load-balancer" {
  value = aws_lb.staging.dns_name
}

output "prod-load-balancer" {
  value = aws_lb.production.dns_name
}

output "dev-db-endpoint" {
  value = aws_lb.development.dns_name
}

output "stg-db-endpoint" {
  value = aws_lb.staging.dns_name
}

output "prod-db-endpoint" {
  value = aws_lb.production.dns_name
}


