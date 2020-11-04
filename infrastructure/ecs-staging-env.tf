resource "aws_key_pair" "mypk-staging" {
  key_name   = "mypk-staging"
  public_key = var.ecs-public-key-staging
}

resource "aws_ecs_cluster" "ecs-cluster-staging" {
  name = var.ecs-cluster-staging
}

resource "aws_instance" "ec2-ecs-staging-env" {
  ami                         = var.ecs-ami-id
  instance_type               = var.ecs-type-instance-staging
  subnet_id                   = aws_subnet.ecs-subnet-staging-1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ecs-measurement-app-sec-group.id]
  key_name                    = aws_key_pair.mypk-staging.id
  iam_instance_profile        = aws_iam_instance_profile.ecs-instance-profile.id
  root_block_device {
    volume_type           = "standard"
    volume_size           = 30
    delete_on_termination = true
  }
  tags = {
    Name = "ec2-ecs-staging-env"
  }
  user_data = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.ecs-cluster-staging} >> /etc/ecs/ecs.config
    EOF
}
