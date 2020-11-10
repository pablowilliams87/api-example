resource "aws_security_group" "public_lb" {
  name = "${var.environment}-lb"
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
    Name        = "${var.environment}-lb"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "ecs" {
  name = "${var.environment}-ecs"
  #  description = "Allow public access"
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.public_lb.id]
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
    Name        = "${var.environment}-ecs"
    Environment = "${var.environment}"
  }
}

resource "aws_key_pair" "pk" {
  key_name   = "${var.environment}-pk"
  public_key = var.ecs_public_key
  tags = {
    Name        = "${var.environment}-pk"
    Environment = "${var.environment}"
  }
}

resource "aws_launch_configuration" "ecs_instances" {
  name = "${var.environment}-ecs"
  #  name_prefix          = "development-ecs-"
  image_id             = var.ecs_ami_id
  key_name             = aws_key_pair.pk.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
  security_groups      = [aws_security_group.ecs.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config"
  instance_type        = var.ecs_instance_type
}

resource "aws_autoscaling_group" "ecs_instances" {
  name                      = "${var.environment}-asg"
  vpc_zone_identifier       = aws_subnet.private.*.id
  launch_configuration      = aws_launch_configuration.ecs_instances.name
  desired_capacity          = var.asg_capacity[0]
  min_size                  = var.asg_capacity[1]
  max_size                  = var.asg_capacity[2]
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.api.arn]
}

resource "aws_lb" "api" {
  name               = "${var.environment}-api"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_lb.id]
  subnets            = aws_subnet.public.*.id
  /*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }
*/
  tags = {
    Name        = "${var.environment}-api"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_target_group" "api" {
  name     = "${var.environment}-api-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
  tags = {
    Name        = "${var.environment}-api"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = 5000
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}
