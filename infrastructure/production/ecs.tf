resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_ecs_task_definition" "api" {
  family                = "${var.environment}-measurement-app"
  container_definitions = <<TASK_DEFINITION
[
    {
        "cpu": ${var.container_cpu},
        "image": "${var.image_tag}",
        "memory": ${var.container_memory},
        "name": "${var.container_name}",
        "portMappings": [{
          "containerPort": 5000,
          "hostPort": 5000
        }],
        "environment":[{  
          "name":"FLASK_ENV",
          "value":"${var.flask_env}"
        },
        {
          "name":"DB_URI",
          "value":"postgresql://${var.rds_user}:${var.rds_pass}@${aws_db_instance.rds.endpoint}/${var.rds_db}"
        },
        {  
          "name":"URL_MEASUREMENTS",
          "value":"${var.url_measurements}"
        }]
    }
]
TASK_DEFINITION
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_ecs_service" "api" {
  name            = "${var.environment}-measurement-app"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = var.container_count
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_ecs_task_definition" "init_db" {
  family                = "${var.environment}-init-db"
  container_definitions = <<TASK_DEFINITION
[
    {
        "cpu": 1,
        "image": "${var.image_tag}",
        "memory": 128,
        "name": "init_db",
        "environment":[{  
          "name":"FLASK_ENV",
          "value":"${var.flask_env}"
        },
        {
          "name":"DB_URI",
          "value":"postgresql://${var.rds_user}:${var.rds_pass}@${aws_db_instance.rds.endpoint}/${var.rds_db}"
        },
        {  
          "name":"URL_MEASUREMENTS",
          "value":"${var.url_measurements}"
        }],
        "command":["flask","initdb"]
    }
]
TASK_DEFINITION
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_ecs_service" "init_db" {
  name            = "${var.environment}-init-db"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.init_db.arn
  desired_count   = var.init_db
  tags = {
    Environment = "${var.environment}"
  }
}
