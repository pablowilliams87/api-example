variable "aws-access-key-id" {
  description = "AWS access key"
}

variable "aws-secret-access-key" {
  description = "AWS secret access key"
}

variable "ecs-cluster-dev" {
  description = "ECS cluster name"
  default     = "ecs-measurement-app-dev"
}

variable "ecs-cluster-staging" {
  description = "ECS cluster name"
  default     = "ecs-measurement-app-staging"
}

variable "ecs-cluster-production" {
  description = "ECS cluster name"
  default     = "ecs-measurement-app-production"
}

variable "ecs-public-key-dev" {
  description = "EC2 instance public key - development environment"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfW21z0xc7gC4/xQBkB1KKBQa3Ox4HWK8Pheu5x+LOQxC6F5frBv8eSd81L5s8k3jRllZWswwEx+ZmfrCkVE5fy86l8II9+FV0wjaohpL3zpOJybUDbH8d+YjrrRcLWfUNVBmhCzF+gDxvBHT9TFW3OCIHqHtfM4UHD89kOx22+o37H/KWdXq4gSan2Z6cju16RH0bqOlXehMTPpPaDr+4c2TfTNBtCBsCO/niktQgq62lKIrJQ05Kh1v9STBqZidzwPmIpJLe+If4uGxk4UM5QnzrcS5+jKcSSWvGZZfeat29aGCyNpfd7wBH7+iiSzmcU4/rKCiv7ByzCBTc+qrp pablow@DESKTOP-K7SL4LU"
}

variable "ecs-public-key-staging" {
  description = "EC2 instance public key - staging environment"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfW21z0xc7gC4/xQBkB1KKBQa3Ox4HWK8Pheu5x+LOQxC6F5frBv8eSd81L5s8k3jRllZWswwEx+ZmfrCkVE5fy86l8II9+FV0wjaohpL3zpOJybUDbH8d+YjrrRcLWfUNVBmhCzF+gDxvBHT9TFW3OCIHqHtfM4UHD89kOx22+o37H/KWdXq4gSan2Z6cju16RH0bqOlXehMTPpPaDr+4c2TfTNBtCBsCO/niktQgq62lKIrJQ05Kh1v9STBqZidzwPmIpJLe+If4uGxk4UM5QnzrcS5+jKcSSWvGZZfeat29aGCyNpfd7wBH7+iiSzmcU4/rKCiv7ByzCBTc+qrp pablow@DESKTOP-K7SL4LU"
}

variable "ecs-public-key-production" {
  description = "EC2 instance public key - production environment"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfW21z0xc7gC4/xQBkB1KKBQa3Ox4HWK8Pheu5x+LOQxC6F5frBv8eSd81L5s8k3jRllZWswwEx+ZmfrCkVE5fy86l8II9+FV0wjaohpL3zpOJybUDbH8d+YjrrRcLWfUNVBmhCzF+gDxvBHT9TFW3OCIHqHtfM4UHD89kOx22+o37H/KWdXq4gSan2Z6cju16RH0bqOlXehMTPpPaDr+4c2TfTNBtCBsCO/niktQgq62lKIrJQ05Kh1v9STBqZidzwPmIpJLe+If4uGxk4UM5QnzrcS5+jKcSSWvGZZfeat29aGCyNpfd7wBH7+iiSzmcU4/rKCiv7ByzCBTc+qrp pablow@DESKTOP-K7SL4LU"
}

variable "ecs-type-instance-production" {
  description = "EC2 instance type - production environment"
  default     = "t3.micro"
}

variable "ecs-type-instance-staging" {
  description = "EC2 instance type - staging environment"
  default     = "t3.micro"
}

variable "ecs-type-instance-dev" {
  description = "EC2 instance type - development environment"
  default     = "t3.micro"
}

variable "ecs-ami-id" {
  description = "EC2 ami-id"
  default     = "ami-0669eafef622afea1"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "availability-zone-1" {
  description = "AWS Availability Zone"
  default     = "us-east-1a"
}

variable "availability-zone-2" {
  description = "AWS Availability Zone"
  default     = "us-east-1b"
}

variable "vpc-subnet" {
  description = "AWS VPC Subnet"
  default     = "10.10.0.0/16"
}

variable "ecs-subnet-dev" {
  description = "AWS ECS Subnet Development"
  default     = "10.10.10.0/24"
}

variable "ecs-subnet-staging-1" {
  description = "AWS ECS Subnet Staging 1"
  default     = "10.10.20.0/24"
}

variable "ecs-subnet-staging-2" {
  description = "AWS ECS Subnet Staging 2"
  default     = "10.10.21.0/24"
}

variable "ecs-subnet-production-1" {
  description = "AWS ECS Subnet Production 1"
  default     = "10.10.30.0/24"
}

variable "ecs-subnet-production-2" {
  description = "AWS ECS Subnet Production 2"
  default     = "10.10.31.0/24"
}

variable "postgres-staging-dbname" {
  description = "AWS RDS Staging DBName"
  default     = "devmeasurementapp"
}

variable "postgres-staging-dbusername" {
  description = "AWS RDS Staging DB Username"
  default     = "postgress"
}

variable "postgres-staging-dbpassword" {
  description = "AWS RDS Staging DB Password"
  default     = "P0stgr3s"
}

variable "postgres-staging-instancetype" {
  description = "AWS RDS Staging DB Instance Type"
  default     = "db.t3.micro"
}

variable "postgres-production-instances" {
  description = "AWS RDS Production Instances"
  default     = "2"
}

variable "postgres-production-dbname" {
  description = "AWS RDS Production DBName"
  default     = "measurementapp"
}

variable "postgres-production-dbusername" {
  description = "AWS RDS Production DB Username"
  default     = "postgress"
}

variable "postgres-production-dbpassword" {
  description = "AWS RDS Production DB Password"
  default     = "P0stgr3s"
}

variable "postgres-production-instancetype" {
  description = "AWS RDS Production DB Instance Type"
  default     = "db.t3.micro"
}