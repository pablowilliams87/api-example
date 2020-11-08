variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_subnet" {
  description = "AWS VPC Subnet"
  default     = "10.10.0.0/16"
}

variable "development_public_subnets" {
  description = "Development Environment Public Subnets"
  default = {
    us-east-1a = "10.10.10.0/24"
  }
}

variable "development_private_subnets" {
  description = "Development Environment Private Subnets"
  default = {
    us-east-1a = "10.10.15.0/24"
  }
}

variable "staging_public_subnets" {
  description = "Staging Environment Public Subnets"
  default = {
    us-east-1a = "10.10.20.0/24"
    us-east-1b = "10.10.21.0/24"
  }
}

variable "staging_private_subnets" {
  description = "Staging Environment Private Subnets"
  default = {
    us-east-1a = "10.10.25.0/24"
    us-east-1b = "10.10.26.0/24"
  }
}

variable "production_public_subnets" {
  description = "Production Environment Public Subnets"
  default = {
    us-east-1a = "10.10.30.0/24"
    us-east-1b = "10.10.31.0/24"
  }
}

variable "production_private_subnets" {
  description = "Production Environment Private Subnets"
  default = {
    us-east-1a = "10.10.35.0/24"
    us-east-1b = "10.10.36.0/24"
  }
}

variable "development_ecs_ami_id" {
  description = "EC2 ami-id"
  default     = "ami-0669eafef622afea1"
}

variable "staging_ecs_ami_id" {
  description = "EC2 ami-id"
  default     = "ami-0669eafef622afea1"
}

variable "production_ecs_ami_id" {
  description = "EC2 ami-id"
  default     = "ami-0669eafef622afea1"
}

variable "development_ecs_cluster" {
  description = "ECS Cluster Name - Development Environment"
  default     = "dev-ecs-measurement-app"
}

variable "staging_ecs_cluster" {
  description = "ECS Cluster Name - Staging Environment"
  default     = "stg-ecs-measurement-app"
}

variable "production_ecs_cluster" {
  description = "ECS Cluster Name - Production Environment"
  default     = "prod-ecs-measurement-app"
}


variable "development_ecs_instance_type" {
  description = "EC2 instance type - development environment"
  default     = "t3.micro"
}

variable "staging_ecs_instance_type" {
  description = "EC2 instance type - staging environment"
  default     = "t3.micro"
}


variable "production_ecs_instance_type" {
  description = "EC2 instance type - production environment"
  default     = "t3.micro"
}


variable "development_ecs_public_key" {
  description = "EC2 instance public key - development environment"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfW21z0xc7gC4/xQBkB1KKBQa3Ox4HWK8Pheu5x+LOQxC6F5frBv8eSd81L5s8k3jRllZWswwEx+ZmfrCkVE5fy86l8II9+FV0wjaohpL3zpOJybUDbH8d+YjrrRcLWfUNVBmhCzF+gDxvBHT9TFW3OCIHqHtfM4UHD89kOx22+o37H/KWdXq4gSan2Z6cju16RH0bqOlXehMTPpPaDr+4c2TfTNBtCBsCO/niktQgq62lKIrJQ05Kh1v9STBqZidzwPmIpJLe+If4uGxk4UM5QnzrcS5+jKcSSWvGZZfeat29aGCyNpfd7wBH7+iiSzmcU4/rKCiv7ByzCBTc+qrp pablow@DESKTOP-K7SL4LU"
}

variable "staging_ecs_public_key" {
  description = "EC2 instance public key - staging environment"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfW21z0xc7gC4/xQBkB1KKBQa3Ox4HWK8Pheu5x+LOQxC6F5frBv8eSd81L5s8k3jRllZWswwEx+ZmfrCkVE5fy86l8II9+FV0wjaohpL3zpOJybUDbH8d+YjrrRcLWfUNVBmhCzF+gDxvBHT9TFW3OCIHqHtfM4UHD89kOx22+o37H/KWdXq4gSan2Z6cju16RH0bqOlXehMTPpPaDr+4c2TfTNBtCBsCO/niktQgq62lKIrJQ05Kh1v9STBqZidzwPmIpJLe+If4uGxk4UM5QnzrcS5+jKcSSWvGZZfeat29aGCyNpfd7wBH7+iiSzmcU4/rKCiv7ByzCBTc+qrp pablow@DESKTOP-K7SL4LU"
}

variable "production_ecs_public_key" {
  description = "EC2 instance public key - production environment"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfW21z0xc7gC4/xQBkB1KKBQa3Ox4HWK8Pheu5x+LOQxC6F5frBv8eSd81L5s8k3jRllZWswwEx+ZmfrCkVE5fy86l8II9+FV0wjaohpL3zpOJybUDbH8d+YjrrRcLWfUNVBmhCzF+gDxvBHT9TFW3OCIHqHtfM4UHD89kOx22+o37H/KWdXq4gSan2Z6cju16RH0bqOlXehMTPpPaDr+4c2TfTNBtCBsCO/niktQgq62lKIrJQ05Kh1v9STBqZidzwPmIpJLe+If4uGxk4UM5QnzrcS5+jKcSSWvGZZfeat29aGCyNpfd7wBH7+iiSzmcU4/rKCiv7ByzCBTc+qrp pablow@DESKTOP-K7SL4LU"
}


variable "development_asg_capacity" {
  description = "ASG Capctity - Development Environment"
  # Desired, Min, Max
  default = [1, 1, 2]
}

variable "staging_asg_capacity" {
  description = "ASG Capctity - Development Environment"
  # Desired, Min, Max
  default = [2, 2, 4]
}

variable "production_asg_capacity" {
  description = "ASG Capctity - Development Environment"
  # Desired, Min, Max
  default = [4, 4, 8]
}

variable "bastion_ami_id" {
  description = "Bastion Host - AMI ID"
  default     = "ami-0947d2ba12ee1ff75"
}

variable "bastion_instance_type" {
  description = "Bastion Host - AMI ID"
  default     = "t2.micro"
}