output "registry" {
  value = aws_ecr_repository.pablow_registry.repository_url
}

output "bastion_host" {
  value = aws_eip.bastion_host.public_ip
}

output "load_balancer" {
  value = aws_lb.api.dns_name
}

