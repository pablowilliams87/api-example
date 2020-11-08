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

variable "url_measurements" {
  description = "URL Measurements"
  default     = "https://gist.githubusercontent.com/jvillarf/040c91397d779d4da02fff54708ca935/raw/f1dbbcbfbc4e3daace7d907a3cc5b716ef808014/environment_airq_measurand.csv"
}

variable "bastion_ami_id" {
  description = "Bastion Host - AMI ID"
  default     = "ami-0947d2ba12ee1ff75"
}

variable "bastion_instance_type" {
  description = "Bastion Host - AMI ID"
  default     = "t2.micro"
}

variable "development_public_subnets" {
  description = "Public Subnets - Development Environment"
  default = {
    us-east-1a = "10.10.10.0/24",
    us-east-1b = "10.10.11.0/24",
  }
}

variable "development_private_subnets" {
  description = "Private Subnets - Development Environment"
  default = {
    us-east-1a = "10.10.15.0/24",
    us-east-1b = "10.10.16.0/24",
  }
}

variable "development_ecs_ami_id" {
  description = "EC2 ami-id - Development Environment"
  default     = "ami-0669eafef622afea1"
}


variable "development_ecs_cluster" {
  description = "ECS Cluster Name - Development Environment"
  default     = "dev-ecs-measurement-app"
}

variable "development_ecs_instance_type" {
  description = "EC2 instance type - Development Environment"
  default     = "t3.micro"
}

variable "development_ecs_public_key" {
  description = "EC2 instance public key - Development Environment"
}

variable "development_asg_capacity" {
  description = "ASG Capactity - Development Environment"
  # Desired, Min, Max
  default = [1, 1, 2]
}

variable "development_rds_db" {
  description = "RDS DB Name - Development Environment"
  default     = "measurementapp"
}

variable "development_rds_user" {
  description = "RDS DB User - Development Environment"
  default     = "postgres"
}

variable "development_rds_pass" {
  description = "RDS DB Pass - Development Environment"
  default     = "P0stgr3s"
}

variable "development_rds_instancetype" {
  description = "RDS DB Instance Type - Development Environment"
  default     = "t2.micro"
}

variable "development_image_tag" {
  description = "ECS API Image Tag - Development Environment"
  default     = "pablowilliams87/measurement-app:1.1"
}

variable "development_container_name" {
  description = "ECS API Container Name - Development Environment"
  default     = "measurement-app-dev"
}

variable "development_container_count" {
  description = "ECS API Container Count - Development Environment"
  default     = 1
}

variable "development_container_cpu" {
  description = "ECS API Container CPU - Development Environment"
  default     = 1
}

variable "development_container_memory" {
  description = "ECS API Container CPU - Development Environment"
  default     = 256
}




variable "staging_public_subnets" {
  description = "Public Subnets - Staging Environment"
  default = {
    us-east-1a = "10.10.20.0/24"
    us-east-1b = "10.10.21.0/24"
  }
}

variable "staging_private_subnets" {
  description = "Private Subnets - Staging Environment"
  default = {
    us-east-1a = "10.10.25.0/24"
    us-east-1b = "10.10.26.0/24"
  }
}

variable "staging_ecs_cluster" {
  description = "ECS Cluster Name - Staging Environment"
  default     = "stg-ecs-measurement-app"
}

variable "staging_ecs_public_key" {
  description = "EC2 instance public key - Staging Environment"
}

variable "staging_ecs_ami_id" {
  description = "EC2 ami-id - Staging Environment"
  default     = "ami-0669eafef622afea1"
}

variable "staging_ecs_instance_type" {
  description = "EC2 instance type - staging Environment"
  default     = "t3.micro"
}

variable "staging_asg_capacity" {
  description = "ASG Capactity - Staging Environment"
  # Desired, Min, Max
  default = [2, 2, 4]
}

variable "staging_rds_db" {
  description = "RDS DB Name - Staging Environment"
  default     = "measurementapp"
}

variable "staging_rds_user" {
  description = "RDS DB User - Staging Environment"
  default     = "postgres"
}

variable "staging_rds_pass" {
  description = "RDS DB Pass - Staging Environment"
  default     = "P0stgr3s"
}

variable "staging_rds_instancetype" {
  description = "RDS DB Instance Type - Staging Environment"
  default     = "t2.micro"
}

variable "staging_image_tag" {
  description = "ECS API Image Tag - Staging Environment"
  default     = "pablowilliams87/measurement-app:1.1"
}

variable "staging_container_name" {
  description = "ECS API Container Name - Staging Environment"
  default     = "measurement-app-dev"
}

variable "staging_container_count" {
  description = "ECS API Container Count - Staging Environment"
  default     = 1
}

variable "staging_container_cpu" {
  description = "ECS API Container CPU - Staging Environment"
  default     = 1
}

variable "staging_container_memory" {
  description = "ECS API Container CPU - Staging Environment"
  default     = 256
}


variable "production_public_subnets" {
  description = "Public Subnets - Production Environment"
  default = {
    us-east-1a = "10.10.30.0/24"
    us-east-1b = "10.10.31.0/24"
  }
}

variable "production_private_subnets" {
  description = "Private Subnets - Production Environment"
  default = {
    us-east-1a = "10.10.35.0/24"
    us-east-1b = "10.10.36.0/24"
  }
}

variable "production_ecs_cluster" {
  description = "ECS Cluster Name - Production Environment"
  default     = "prod-ecs-measurement-app"
}

variable "production_ecs_public_key" {
  description = "EC2 instance public key - Production Environment"
}

variable "production_ecs_ami_id" {
  description = "EC2 ami-id - Production Environment"
  default     = "ami-0669eafef622afea1"
}

variable "production_ecs_instance_type" {
  description = "EC2 instance type - production environment"
  default     = "t3.micro"
}

variable "production_asg_capacity" {
  description = "ASG Capactity - Production Environment"
  # Desired, Min, Max
  default = [4, 4, 8]
}

variable "production_rds_db" {
  description = "RDS DB Name - Production Environment"
  default     = "measurementapp"
}

variable "production_rds_user" {
  description = "RDS DB User - Production Environment"
  default     = "postgres"
}

variable "production_rds_pass" {
  description = "RDS DB Pass - Production Environment"
  default     = "P0stgr3s"
}

variable "production_rds_instancetype" {
  description = "RDS DB Instance Type - Production Environment"
  default     = "t2.micro"
}

variable "production_image_tag" {
  description = "ECS API Image Tag - Production Environment"
  default     = "pablowilliams87/measurement-app:1.1"
}

variable "production_container_name" {
  description = "ECS API Container Name - Production Environment"
  default     = "measurement-app-dev"
}

variable "production_container_count" {
  description = "ECS API Container Count - Production Environment"
  default     = 1
}

variable "production_container_cpu" {
  description = "ECS API Container CPU - Production Environment"
  default     = 1
}

variable "production_container_memory" {
  description = "ECS API Container CPU - Production Environment"
  default     = 256
}

