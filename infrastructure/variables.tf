variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}

variable "ecs_cluster_dev" {
  description = "ECS cluster name"
  default     = "ecs-measurement-app-dev"
}

variable "ecs_cluster_staging" {
  description = "ECS cluster name"
  default     = "ecs-measurement-app-staging"
}

variable "ecs_cluster_production" {
  description = "ECS cluster name"
  default     = "ecs-measurement-app-production"
}

variable "ecs_public_key_dev" {
  description = "EC2 instance public key - development environment"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfW21z0xc7gC4/xQBkB1KKBQa3Ox4HWK8Pheu5x+LOQxC6F5frBv8eSd81L5s8k3jRllZWswwEx+ZmfrCkVE5fy86l8II9+FV0wjaohpL3zpOJybUDbH8d+YjrrRcLWfUNVBmhCzF+gDxvBHT9TFW3OCIHqHtfM4UHD89kOx22+o37H/KWdXq4gSan2Z6cju16RH0bqOlXehMTPpPaDr+4c2TfTNBtCBsCO/niktQgq62lKIrJQ05Kh1v9STBqZidzwPmIpJLe+If4uGxk4UM5QnzrcS5+jKcSSWvGZZfeat29aGCyNpfd7wBH7+iiSzmcU4/rKCiv7ByzCBTc+qrp pablow@DESKTOP-K7SL4LU"
}

variable "ecs_public_key_staging" {
  description = "EC2 instance public key - staging environment"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfW21z0xc7gC4/xQBkB1KKBQa3Ox4HWK8Pheu5x+LOQxC6F5frBv8eSd81L5s8k3jRllZWswwEx+ZmfrCkVE5fy86l8II9+FV0wjaohpL3zpOJybUDbH8d+YjrrRcLWfUNVBmhCzF+gDxvBHT9TFW3OCIHqHtfM4UHD89kOx22+o37H/KWdXq4gSan2Z6cju16RH0bqOlXehMTPpPaDr+4c2TfTNBtCBsCO/niktQgq62lKIrJQ05Kh1v9STBqZidzwPmIpJLe+If4uGxk4UM5QnzrcS5+jKcSSWvGZZfeat29aGCyNpfd7wBH7+iiSzmcU4/rKCiv7ByzCBTc+qrp pablow@DESKTOP-K7SL4LU"
}

variable "ecs_public_key_production" {
  description = "EC2 instance public key - production environment"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfW21z0xc7gC4/xQBkB1KKBQa3Ox4HWK8Pheu5x+LOQxC6F5frBv8eSd81L5s8k3jRllZWswwEx+ZmfrCkVE5fy86l8II9+FV0wjaohpL3zpOJybUDbH8d+YjrrRcLWfUNVBmhCzF+gDxvBHT9TFW3OCIHqHtfM4UHD89kOx22+o37H/KWdXq4gSan2Z6cju16RH0bqOlXehMTPpPaDr+4c2TfTNBtCBsCO/niktQgq62lKIrJQ05Kh1v9STBqZidzwPmIpJLe+If4uGxk4UM5QnzrcS5+jKcSSWvGZZfeat29aGCyNpfd7wBH7+iiSzmcU4/rKCiv7ByzCBTc+qrp pablow@DESKTOP-K7SL4LU"
}

variable "ecs_type_instance_production" {
  description = "EC2 instance type - production environment"
  default     = "t3.micro"
}

variable "ecs_type_instance_staging" {
  description = "EC2 instance type - staging environment"
  default     = "t3.micro"
}

variable "ecs_type_instance_dev" {
  description = "EC2 instance type - development environment"
  default     = "t3.micro"
}

variable "ecs_ami_id" {
  description = "EC2 ami-id"
  default     = "ami-0669eafef622afea1"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "AWS Availability Zone"
  default     = "us-east-1a"
}

variable "vpc_subnet" {
  description = "AWS VPC Subnet"
  default     = "10.10.0.0/16"
}

variable "ecs_subnet_dev" {
  description = "AWS ECS Subnet"
  default     = "10.10.0.0/24"
}

variable "ecs_subnet_staging" {
  description = "AWS ECS Subnet"
  default     = "10.10.1.0/24"
}

variable "ecs_subnet_production" {
  description = "AWS ECS Subnet"
  default     = "10.10.2.0/24"
}