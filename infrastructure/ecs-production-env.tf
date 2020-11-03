resource "aws_key_pair" "mypk_prod" {
  key_name   = "mypk_prod"
  public_key = var.ecs_public_key_production
}

resource "aws_ecs_cluster" "ecs-cluster-production" {
  name = var.ecs_cluster_production
}

resource "aws_instance" "ec2-ecs-production-env" {
  ami                         = var.ecs_ami_id
  instance_type               = var.ecs_type_instance_production
  subnet_id                   = aws_subnet.ecs-subnet-production.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ecs-measurement-app-sec-group.id]
  key_name                    = aws_key_pair.mypk_prod.id
  iam_instance_profile        = aws_iam_instance_profile.ecs-instance-profile.id
  root_block_device {
    volume_type           = "standard"
    volume_size           = 30
    delete_on_termination = true
  }
  tags = {
    Name = "ec2-ecs-production-env"
  }
  user_data = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs_cluster_production} >> /etc/ecs/ecs.config
                                  EOF
}



