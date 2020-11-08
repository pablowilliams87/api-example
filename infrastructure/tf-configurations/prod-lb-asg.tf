resource "aws_security_group" "production_lb" {
  name = "production_lb"
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
    Name        = "production_lb"
    Environment = "production"
  }
}

resource "aws_security_group" "production_ecs" {
  name = "production_ecs"
  #  description = "Allow public access"
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.production_lb.id]
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
    Name        = "production_ecs"
    Environment = "production"
  }
}

resource "aws_key_pair" "production_pk" {
  key_name   = "production_pk"
  public_key = var.production_ecs_public_key
  tags = {
    Name        = "production_pk"
    Environment = "production"
  }
}

resource "aws_launch_configuration" "production" {
  #  name                 = "prouction-lc"
  name_prefix          = "production-ecs-"
  image_id             = var.production_ecs_ami_id
  key_name             = aws_key_pair.production_pk.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
  security_groups      = [aws_security_group.production_ecs.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.production_ecs_cluster} >> /etc/ecs/ecs.config"
  instance_type        = var.production_ecs_instance_type
}

resource "aws_autoscaling_group" "production" {
  name                      = "production-asg"
  vpc_zone_identifier       = aws_subnet.production_private.*.id
  launch_configuration      = aws_launch_configuration.production.name
  desired_capacity          = var.production_asg_capacity[0]
  min_size                  = var.production_asg_capacity[1]
  max_size                  = var.production_asg_capacity[2]
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.production_api.arn]
}

resource "aws_lb" "production" {
  name               = "production-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.production_lb.id]
  subnets            = aws_subnet.production_public.*.id
  /*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }
*/
  tags = {
    Name        = "production_lb"
    Environment = "production"
  }
}

resource "aws_lb_target_group" "production_api" {
  name     = "production-api-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
  tags = {
    Name        = "production_api"
    Environment = "production"
  }
}

resource "aws_lb_listener" "production_api" {
  load_balancer_arn = aws_lb.production.arn
  port              = 5000
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.production_api.arn
  }
}
