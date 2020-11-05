resource "aws_key_pair" "mypk-dev" {
  key_name   = "mypk-dev"
  public_key = var.ecs-public-key-staging
}

resource "aws_ecs_cluster" "ecs-cluster-dev" {
  name = var.ecs-cluster-dev
}

resource "aws_instance" "ec2-ecs-dev-env" {
  ami                         = var.ecs-ami-id
  instance_type               = var.ecs-type-instance-dev
  subnet_id                   = aws_subnet.ecs-subnet-dev.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ecs-measurement-app-sec-group.id]
  key_name                    = aws_key_pair.mypk-dev.id
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
    echo ECS_CLUSTER=${var.ecs-cluster-dev} >> /etc/ecs/ecs.config
    EOF
}

resource "aws_ecs_task_definition" "postgres-ecs-task-definition" {
  family = "postgres"
  volume {
    name      = "service-storage"
    host_path = "/datafiles/database/postgres"
  }
  container_definitions = <<TASK_DEFINITION
[
    {
        "cpu": 2,
        "environment": [
            {"name": "POSTGRES_PASSWORD", "value": "P0stgr3s"}
        ],
        "image": "postgres:11.8-alpine",
        "memory": 256,
        "name": "postgres",
        "portMappings": [
            {
                "containerPort": 5432,
                "hostPort": 5432
            }
        ]
    }
]
TASK_DEFINITION
}

resource "aws_ecs_service" "postgres-ecs-service" {
  name            = "postgres"
  cluster         = aws_ecs_cluster.ecs-cluster-dev.id
  task_definition = aws_ecs_task_definition.postgres-ecs-task-definition.arn
  desired_count   = 1
  /*
  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "mongo"
    container_port   = 8080
  }
*/
}

resource "aws_ecs_task_definition" "app-ecs-task-definition" {
  family = "measurement-app-dev"
  container_definitions = <<TASK_DEFINITION
[
    {
        "cpu": 2,
        "image": "postgres:11.8-alpine",
        "memory": 256,
        "name": "measurement-app-dev"
    }
]
TASK_DEFINITION
}

resource "aws_ecs_service" "app-ecs-service" {
  name            = "measurement-app-dev"
  cluster         = aws_ecs_cluster.ecs-cluster-dev.id
  task_definition = aws_ecs_task_definition.app-ecs-task-definition.arn
  desired_count   = 1
  /*
  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "mongo"
    container_port   = 8080
  }
*/
}

