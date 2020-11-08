resource "aws_ecs_cluster" "development" {
  name = var.development_ecs_cluster
  tags = {
    Environment = "development"
  }
}

resource "aws_ecs_task_definition" "development_api" {
  family                = "measurement-app-dev"
  container_definitions = <<TASK_DEFINITION
[
    {
        "cpu": ${var.development_container_cpu},
        "image": "${var.development_image_tag}",
        "memory": ${var.development_container_memory},
        "name": "${var.development_container_name}",
        "portMappings": [{
          "containerPort": 5000,
          "hostPort": 5000
        }],
        "environment":[{  
          "name":"FLASK_ENV",
          "value":"development"
        },
        {
          "name":"DB_URI",
          "value":"postgresql://${var.development_rds_user}:${var.development_rds_pass}@${aws_db_instance.development_rds.endpoint}/${var.development_rds_db}"
        },
        {  
          "name":"URL_MEASUREMENTS",
          "value":"${var.url_measurements}"
        }]
    }
]
TASK_DEFINITION
  tags = {
    Environment = "development"
  }
}

resource "aws_ecs_service" "development_api" {
  name            = "measurement-app-dev"
  cluster         = aws_ecs_cluster.development.id
  task_definition = aws_ecs_task_definition.development_api.arn
  desired_count   = var.development_container_count
  tags = {
    Environment = "development"
  }
}
