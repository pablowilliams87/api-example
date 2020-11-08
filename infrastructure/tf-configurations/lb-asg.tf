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
