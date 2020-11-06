output "registry" {
  value = aws_ecr_repository.registry.repository_url
}

output "ecs-production-env-ip" {
  value = aws_instance.ec2-ecs-production-env.public_ip
}

output "ecs-staging-env-ip" {
  value = aws_instance.ec2-ecs-staging-env.public_ip
}

output "ecs-dev-env-ip" {
  value = aws_instance.ec2-ecs-dev-env.public_ip
}