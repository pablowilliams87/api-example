resource "aws_ecs_cluster" "production" {
  name = var.production_ecs_cluster
  tags = {
    Environment = "production"
  }
}

resource "aws_ecs_task_definition" "production_api" {
  family                = "measurement-app-prod"
  container_definitions = <<TASK_DEFINITION
[
    {
        "cpu": ${var.production_container_cpu},
        "image": "${var.production_image_tag}",
        "memory": ${var.production_container_memory},
        "name": "${var.production_container_name}",
        "portMappings": [{
          "containerPort": 5000,
          "hostPort": 5000
        }],
        "environment":[{  
          "name":"FLASK_ENV",
          "value":"production"
        },
        {
          "name":"DB_URI",
          "value":"postgresql://${var.production_rds_user}:${var.production_rds_pass}@${aws_db_instance.production_rds.endpoint}/${var.production_rds_db}"
        },
        {  
          "name":"URL_MEASUREMENTS",
          "value":"${var.url_measurements}"
        }]
    }
]
TASK_DEFINITION
  tags = {
    Environment = "production"
  }
}

resource "aws_ecs_service" "production_api" {
  name            = "measurement-app-prod"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.production_api.arn
  desired_count   = var.production_container_count
  tags = {
    Environment = "production"
  }
}
