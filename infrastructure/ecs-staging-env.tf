resource "aws_key_pair" "mypk_staging" {
  key_name   = "mypk_staging"
  public_key = var.ecs_public_key_staging
}

resource "aws_ecs_cluster" "ecs-cluster-staging" {
  name = var.ecs_cluster_staging
}

resource "aws_instance" "ec2-ecs-staging-env" {
  ami                         = var.ecs_ami_id
  instance_type               = var.ecs_type_instance_staging
  subnet_id                   = aws_subnet.ecs-subnet-staging.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ecs-measurement-app-sec-group.id]
  key_name                    = aws_key_pair.mypk_staging.id
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
                                  echo ECS_CLUSTER=${var.ecs_cluster_staging} >> /etc/ecs/ecs.config
                                  EOF
}



