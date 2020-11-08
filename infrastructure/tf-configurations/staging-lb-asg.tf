resource "aws_security_group" "staging_lb" {
  name = "staging_lb"
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
    Name        = "staging_lb"
    Environment = "staging"
  }
}

resource "aws_security_group" "staging_ecs" {
  name = "staging_ecs"
  #  description = "Allow public access"
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.staging_lb.id]
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
    Name        = "staging_ecs"
    Environment = "staging"
  }
}

resource "aws_key_pair" "staging_pk" {
  key_name   = "staging_pk"
  public_key = var.staging_ecs_public_key
  tags = {
    Name        = "staging_pk"
    Environment = "staging"
  }
}

resource "aws_launch_configuration" "staging" {
  #  name                 = "staging-lc"
  name_prefix          = "staging-ecs-"
  image_id             = var.staging_ecs_ami_id
  key_name             = aws_key_pair.staging_pk.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
  security_groups      = [aws_security_group.staging_ecs.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.staging_ecs_cluster} >> /etc/ecs/ecs.config"
  instance_type        = var.staging_ecs_instance_type
}

resource "aws_autoscaling_group" "staging" {
  name                      = "staging-asg"
  vpc_zone_identifier       = aws_subnet.staging_private.*.id
  launch_configuration      = aws_launch_configuration.staging.name
  desired_capacity          = var.staging_asg_capacity[0]
  min_size                  = var.staging_asg_capacity[1]
  max_size                  = var.staging_asg_capacity[2]
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.staging_api.arn]
}

resource "aws_lb" "staging" {
  name               = "staging-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.staging_lb.id]
  subnets            = aws_subnet.staging_public.*.id
  /*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }
*/
  tags = {
    Name        = "staging_lb"
    Environment = "staging"
  }
}

resource "aws_lb_target_group" "staging_api" {
  name     = "staging-api-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
  tags = {
    Name        = "staging_api"
    Environment = "staging"
  }
}

resource "aws_lb_listener" "staging_api" {
  load_balancer_arn = aws_lb.staging.arn
  port              = 5000
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.staging_api.arn
  }
}
