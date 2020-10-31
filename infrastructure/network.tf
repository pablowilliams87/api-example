resource "aws_vpc" "custom-vpc" {
  cidr_block = var.vpc_subnet
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

resource "aws_subnet" "ecs-subnet" {
  vpc_id            = aws_vpc.custom-vpc.id
  cidr_block        = var.ecs_subnet
  availability_zone = var.availability_zone
  tags = {
    Name = "ecs-measurement-api-subnet"
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

resource "aws_route_table_association" "ecs-subnet-tr-assoc" {
  subnet_id      = aws_subnet.ecs-subnet.id
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