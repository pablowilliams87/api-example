resource "aws_vpc" "custom-vpc" {
  cidr_block           = var.vpc-subnet
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "custom-vpc"
  }
}

resource "aws_internet_gateway" "custom-igw" {
  vpc_id = aws_vpc.custom-vpc.id
  tags = {
    Name = "custom-igw"
  }
}

resource "aws_subnet" "ecs-subnet-dev" {
  vpc_id            = aws_vpc.custom-vpc.id
  cidr_block        = var.ecs-subnet-dev
  availability_zone = var.availability-zone-1
  tags = {
    Name = "ecs-measurement-api-subnet-dev"
  }
}

resource "aws_subnet" "ecs-subnet-staging-1" {
  vpc_id            = aws_vpc.custom-vpc.id
  cidr_block        = var.ecs-subnet-staging-1
  availability_zone = var.availability-zone-1
  tags = {
    Name = "ecs-measurement-api-subnet-staging"
  }
}

resource "aws_subnet" "ecs-subnet-staging-2" {
  vpc_id            = aws_vpc.custom-vpc.id
  cidr_block        = var.ecs-subnet-staging-2
  availability_zone = var.availability-zone-2
  tags = {
    Name = "ecs-measurement-api-subnet-staging"
  }
}

resource "aws_subnet" "ecs-subnet-production-1" {
  vpc_id            = aws_vpc.custom-vpc.id
  cidr_block        = var.ecs-subnet-production-1
  availability_zone = var.availability-zone-1
  tags = {
    Name = "ecs-measurement-api-subnet-production"
  }
}

resource "aws_subnet" "ecs-subnet-production-2" {
  vpc_id            = aws_vpc.custom-vpc.id
  cidr_block        = var.ecs-subnet-production-2
  availability_zone = var.availability-zone-2
  tags = {
    Name = "ecs-measurement-api-subnet-production"
  }
}

resource "aws_route_table" "ecs-route-table" {
  vpc_id = aws_vpc.custom-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom-igw.id
  }
  tags = {
    Name = "ecs-measurement-routing-table"
  }
}

resource "aws_route_table_association" "ecs-subnet-dev-assoc" {
  subnet_id      = aws_subnet.ecs-subnet-dev.id
  route_table_id = aws_route_table.ecs-route-table.id
}

resource "aws_route_table_association" "ecs-subnet-staging-assoc-1" {
  subnet_id      = aws_subnet.ecs-subnet-staging-1.id
  route_table_id = aws_route_table.ecs-route-table.id
}

resource "aws_route_table_association" "ecs-subnet-staging-assoc-2" {
  subnet_id      = aws_subnet.ecs-subnet-staging-2.id
  route_table_id = aws_route_table.ecs-route-table.id
}

resource "aws_route_table_association" "ecs-subnet-production-assoc-1" {
  subnet_id      = aws_subnet.ecs-subnet-production-1.id
  route_table_id = aws_route_table.ecs-route-table.id
}

resource "aws_route_table_association" "ecs-subnet-production-assoc-2" {
  subnet_id      = aws_subnet.ecs-subnet-production-2.id
  route_table_id = aws_route_table.ecs-route-table.id
}

resource "aws_security_group" "ecs-measurement-app-sec-group" {
  name        = "ecs-measurement-app-sec-group"
  description = "Allow public access"
  vpc_id      = aws_vpc.custom-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  /*
   ingress {
      from_port = 0
      to_port = 0
      protocol = "tcp"
      cidr_blocks = [
         "${var.test_public_01_cidr}",
         "${var.test_public_02_cidr}"]
    }
*/
  egress {
    # Allow all Egress Traffic
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = {
    Name = "ecs-measurement-app-sec-group"
  }
}