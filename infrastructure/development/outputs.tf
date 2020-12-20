output "bastion_host" {
  value = aws_eip.bastion_host.public_ip
}

output "load_balancer_dns_name" {
  value = aws_lb.api.dns_name
}
