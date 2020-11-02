resource "aws_key_pair" "mypk_dev" {
  key_name   = "mypk_dev"
  public_key = var.ecs_public_key_staging
}

resource "aws_ecs_cluster" "ecs-dev-env" {
  name = var.ecs_cluster_dev
}

resource "aws_instance" "ec2-ecs-dev-env" {
  ami                         = var.ecs_ami_id
  instance_type               = var.ecs_type_instance_dev
  subnet_id                   = aws_subnet.ecs-subnet-dev.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ecs-measurement-app-sec-group.id]
  key_name                    = aws_key_pair.mypk_dev.id
  iam_instance_profile        = aws_iam_instance_profile.ecs-instance-profile.id
  root_block_device {
    volume_type           = "standard"
    volume_size           = 30
    delete_on_termination = true
  }
  tags = {
    Name = "ec2-ecs-dev-env"
  }
  user_data = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs_cluster_dev} >> /etc/ecs/ecs.config
                                  EOF
}



