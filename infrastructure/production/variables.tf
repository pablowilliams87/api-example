variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_subnet" {
  description = "AWS VPC Subnet"
  default     = "10.10.0.0/16"
}

variable "environment" {
  description = "Environment"
  default     = "development"
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

variable "public_subnets" {
  description = "Public Subnets"
  default = {
    us-east-1a = "10.10.10.0/24",
    us-east-1b = "10.10.11.0/24",
  }
}

variable "private_subnets" {
  description = "Private Subnets"
  default = {
    us-east-1a = "10.10.15.0/24",
    us-east-1b = "10.10.16.0/24",
  }
}

variable "ecs_ami_id" {
  description = "EC2 ami-id"
  default     = "ami-0669eafef622afea1"
}


variable "ecs_cluster" {
  description = "ECS Cluster Name"
  default     = "dev-ecs-measurement-app"
}

variable "ecs_instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ecs_public_key" {
  description = "EC2 instance public key"
}

variable "asg_capacity" {
  description = "ASG Capactity"
  # Desired, Min, Max
  default = [1, 1, 2]
}

variable "rds_db" {
  description = "RDS DB Name"
  default     = "measurementapp"
}

variable "rds_user" {
  description = "RDS DB User"
  default     = "postgres"
}

variable "rds_instancetype" {
  description = "RDS DB Instance Type"
  default     = "t2.micro"
}

variable "image_tag" {
  description = "ECS API Image Tag"
  default     = "pablowilliams87/measurement-app:1.1"
}

variable "container_name" {
  description = "ECS API Container Name"
  default     = "production-measurement-app"
}

variable "container_count" {
  description = "ECS API Container Count"
  default     = 1
}

variable "container_cpu" {
  description = "ECS API Container CPU"
  default     = 1
}

variable "container_memory" {
  description = "ECS API Container CPU"
  default     = 256
}

variable "container_status_path" {
  description = "ECS Container Status Path"
  default     = "/status"
}

variable "flask_env" {
  description = "FLASK_ENV var"
  default     = "development"
}

variable "init_db" {
  description = "Initialize postgres DB"
  default     = "0"
}