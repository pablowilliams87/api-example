resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_subnet
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}-custom-vpc"
  }
}

resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "${var.environment}-custom-igw"
  }
}

resource "aws_eip" "nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.custom_igw]
}

# NAT Gateway will be located on the first subnet
resource "aws_nat_gateway" "custom_natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.0.id
  depends_on    = [aws_internet_gateway.custom_igw]
}


resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(values(var.public_subnets), count.index)
  availability_zone = element(keys(var.public_subnets), count.index)
  tags = {
    Name = "${var.environment}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(values(var.private_subnets), count.index)
  availability_zone = element(keys(var.private_subnets), count.index)
  tags = {
    Name = "${var.environment}-private-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }
  tags = {
    Name = "${var.environment}-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.custom_natgw.id
  }
  tags = {
    Name = "${var.environment}-private"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


resource "aws_security_group" "bastion_host" {
  name   = "bastion-host"
  vpc_id = aws_vpc.custom_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion_host" {
  ami                    = var.bastion_ami_id
  instance_type          = var.bastion_instance_type
  key_name               = aws_key_pair.pk.key_name
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  subnet_id              = aws_subnet.public.0.id
  tags = {
    Name = "${var.environment}-bastion-host"
  }
}

resource "aws_eip" "bastion_host" {
  instance = aws_instance.bastion_host.id
  vpc      = true
}
