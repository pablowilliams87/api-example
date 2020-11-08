terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

/*
    NETWORK
*/
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
  #  subnet_id     = element(values(var.production_public_subnets), 0)
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
  /*  Creo que no hace falta enrutar mas que el default
  dynamic "route" {
    for_each = keys(var.production_private_subnets)
    content {
      cidr_block = route.value
      gateway_id = aws_nat_gateway.custom_natgw.id
    }
  }
*/
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

  #  subnet_id      = element(values(var.development_public_subnets), count.index)
  subnet_id      = element(aws_subnet.development_public.*.id, count.index)
  route_table_id = aws_route_table.development_public.id
}

resource "aws_route_table_association" "development_private" {
  count = length(var.development_private_subnets)

  #  subnet_id      = element(values(var.development_public_subnets), count.index)
  subnet_id      = element(aws_subnet.development_private.*.id, count.index)
  route_table_id = aws_route_table.development_private.id
}


resource "aws_route_table_association" "staging_public" {
  count = length(var.staging_public_subnets)

  #  subnet_id      = element(values(var.staging_public_subnets), count.index)
  subnet_id      = element(aws_subnet.staging_public.*.id, count.index)
  route_table_id = aws_route_table.staging_public.id
}

resource "aws_route_table_association" "staging_private" {
  count = length(var.staging_public_subnets)

  #  subnet_id      = element(values(var.staging_public_subnets), count.index)
  subnet_id      = element(aws_subnet.staging_public.*.id, count.index)
  route_table_id = aws_route_table.staging_public.id
}

resource "aws_route_table_association" "production_public" {
  count = length(var.production_public_subnets)

  #  subnet_id      = element(values(var.production_public_subnets), count.index)
  subnet_id      = element(aws_subnet.production_public.*.id, count.index)
  route_table_id = aws_route_table.production_public.id
}

resource "aws_route_table_association" "production_private" {
  count = length(var.production_public_subnets)

  #  subnet_id      = element(values(var.production_public_subnets), count.index)
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
/*
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# this resource will create a key pair using above private key
resource "aws_key_pair" "key_pair" {
  key_name   = "terra_key"
  public_key = tls_private_key.private_key.public_key_openssh
}

# this resource will save the private key at our specified path.
resource "local_file" "saveKey" {
  content  = tls_private_key.private_key.private_key_pem
  filename = "terra_key.pem"
}
*/
resource "aws_instance" "bastion_host" {
  ami                    = var.bastion_ami_id
  instance_type          = var.bastion_instance_type
  key_name               = aws_key_pair.development_pk.key_name
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  subnet_id              = aws_subnet.staging_public.0.id
  tags = {
    Name = "bastion-host"
  } /*
  provisioner "file" {
    source      = "terra_key.pem"
    destination = "/home/ec2-user/terra_key.pem"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.private_key.private_key_pem
      host        = self.public_ip
    }
  }*/
}

resource "aws_eip" "bastion_host" {
  instance = aws_instance.bastion_host.id
  vpc      = true
}



/*
  IAM
*/

## ECS Service Role
resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs-service-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_attachment" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}


## ECS Instance Role
resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecs-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_policy.json
}

data "aws_iam_policy_document" "ecs_instance_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs_instance_role.id
  /*    provisioner "local-exec" {
      command = "sleep 10"
    }*/
}



/*
  LB - ASG
*/

resource "aws_security_group" "development_ecs" {
  name = "development_ecs"
  #  description = "Allow public access"
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.development_lb.id]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host.id]
  }
  egress {
    # Allow all Egress Traffic
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = {
    Name        = "development_ecs"
    Environment = "development"
  }
}

resource "aws_security_group" "development_lb" {
  name = "development_lb"
  #  description = "Allow public access"
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    # Allow all Egress Traffic
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "development_lb"
    Environment = "development"
  }
}

resource "aws_key_pair" "development_pk" {
  key_name   = "development_pk"
  public_key = var.development_ecs_public_key
}

resource "aws_launch_configuration" "development" {
  image_id             = var.development_ecs_ami_id
  key_name             = aws_key_pair.development_pk.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
  security_groups      = [aws_security_group.development_ecs.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.development_ecs_cluster} >> /etc/ecs/ecs.config"
  instance_type        = var.development_ecs_instance_type
}

resource "aws_autoscaling_group" "development" {
  name                = "development-asg"
  vpc_zone_identifier = aws_subnet.development_private.*.id
  #values(var.development_public_subnets)
  # availability_zones        = keys(var.development_private_subnets)
  launch_configuration      = aws_launch_configuration.development.name
  desired_capacity          = var.development_asg_capacity[0]
  min_size                  = var.development_asg_capacity[1]
  max_size                  = var.development_asg_capacity[2]
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.development_api.arn]
}

resource "aws_lb" "development" {
  name               = "development-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.development_lb.id]
  subnets            = aws_subnet.development_public.*.id
  #  enable_deletion_protection = true
  /*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }
*/
  tags = {
    Environment = "Development"
  }
}

resource "aws_lb_target_group" "development_api" {
  name     = "development-api-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
}

resource "aws_lb_listener" "development_api" {
  load_balancer_arn = aws_lb.development.arn
  port              = 5000
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.development_api.arn
  }
}


/*
    ECR
*/

resource "aws_ecr_repository" "pablow-registry" {
  name = "registry"
}


/*
    ECS
*/

resource "aws_ecs_cluster" "development" {
  name = var.development_ecs_cluster
}

resource "aws_ecs_task_definition" "development_api" {
  family                = "measurement-app-dev"
  container_definitions = <<TASK_DEFINITION
[
    {
        "cpu": 2,
        "image": "nginx:1.18.0",
        "memory": 256,
        "name": "measurement-app-dev",
        "portMappings": [{
          "containerPort": 80,
          "hostPort": 5000
        }]
    }
]
TASK_DEFINITION
}

resource "aws_ecs_service" "development_api" {
  name            = "measurement-app-dev"
  cluster         = aws_ecs_cluster.development.id
  task_definition = aws_ecs_task_definition.development_api.arn
  desired_count   = 1
}


