resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_subnet
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "custom_vpc"
  }
}

resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "custom_igw"
  }
}

resource "aws_eip" "nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.custom_igw]
}

# NAT Gateway will be located on the first production subnet
resource "aws_nat_gateway" "custom_natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id  = aws_subnet.production_public.0.id
  depends_on = [aws_internet_gateway.custom_igw]
}


resource "aws_subnet" "development_public" {
  count = length(var.development_public_subnets)

  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(values(var.development_public_subnets), count.index)
  availability_zone = element(keys(var.development_public_subnets), count.index)
  tags = {
    Name = "development_public_${count.index}"
  }
}

resource "aws_subnet" "development_private" {
  count = length(var.development_private_subnets)

  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(values(var.development_private_subnets), count.index)
  availability_zone = element(keys(var.development_private_subnets), count.index)
  tags = {
    Name = "development_private_${count.index}"
  }
}

resource "aws_subnet" "staging_public" {
  count = length(var.staging_public_subnets)

  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(values(var.staging_public_subnets), count.index)
  availability_zone = element(keys(var.staging_public_subnets), count.index)
  tags = {
    Name = "staging_public_${count.index}"
  }
}

resource "aws_subnet" "staging_private" {
  count = length(var.staging_private_subnets)

  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(values(var.staging_private_subnets), count.index)
  availability_zone = element(keys(var.staging_private_subnets), count.index)
  tags = {
    Name = "staging_private_${count.index}"
  }
}

resource "aws_subnet" "production_public" {
  count = length(var.production_public_subnets)

  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(values(var.production_public_subnets), count.index)
  availability_zone = element(keys(var.production_public_subnets), count.index)
  tags = {
    Name = "production_public_${count.index}"
  }
}

resource "aws_subnet" "production_private" {
  count = length(var.production_private_subnets)

  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(values(var.production_private_subnets), count.index)
  availability_zone = element(keys(var.production_private_subnets), count.index)
  tags = {
    Name = "production_private_${count.index}"
  }
}

resource "aws_route_table" "development_public" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }
  tags = {
    Name = "public-development-route-table"
  }
}

resource "aws_route_table" "staging_public" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }
  tags = {
    Name = "public-staging-route-table"
  }
}

resource "aws_route_table" "production_public" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }
  tags = {
    Name = "public-production-route-table"
  }
}

resource "aws_route_table" "development_private" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.custom_natgw.id
  }

  tags = {
    Name = "private-development-route-table"
  }
}

resource "aws_route_table" "staging_private" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.custom_natgw.id
  }
  tags = {
    Name = "private-staging-route-table"
  }
}

resource "aws_route_table" "production_private" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.custom_natgw.id
  }
  tags = {
    Name = "private-production-route-table"
  }
}

resource "aws_route_table_association" "development_public" {
  count = length(var.development_public_subnets)

  subnet_id      = element(aws_subnet.development_public.*.id, count.index)
  route_table_id = aws_route_table.development_public.id
}

resource "aws_route_table_association" "development_private" {
  count = length(var.development_private_subnets)

  subnet_id      = element(aws_subnet.development_private.*.id, count.index)
  route_table_id = aws_route_table.development_private.id
}


resource "aws_route_table_association" "staging_public" {
  count = length(var.staging_public_subnets)

  subnet_id      = element(aws_subnet.staging_public.*.id, count.index)
  route_table_id = aws_route_table.staging_public.id
}

resource "aws_route_table_association" "staging_private" {
  count = length(var.staging_public_subnets)

  subnet_id      = element(aws_subnet.staging_public.*.id, count.index)
  route_table_id = aws_route_table.staging_public.id
}

resource "aws_route_table_association" "production_public" {
  count = length(var.production_public_subnets)

  subnet_id      = element(aws_subnet.production_public.*.id, count.index)
  route_table_id = aws_route_table.production_public.id
}

resource "aws_route_table_association" "production_private" {
  count = length(var.production_public_subnets)

  subnet_id      = element(aws_subnet.production_public.*.id, count.index)
  route_table_id = aws_route_table.production_public.id
}

resource "aws_security_group" "bastion_host" {
  name   = "sh-bastion-host"
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
  key_name               = aws_key_pair.development_pk.key_name
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  subnet_id              = aws_subnet.staging_public.0.id
  tags = {
    Name = "bastion-host"
  }
}

resource "aws_eip" "bastion_host" {
  instance = aws_instance.bastion_host.id
  vpc      = true
}
