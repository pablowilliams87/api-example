resource "aws_ecs_cluster" "staging" {
  name = var.staging_ecs_cluster
  tags = {
    Environment = "staging"
  }
}

resource "aws_ecs_task_definition" "staging_api" {
  family                = "measurement-app-staging"
  container_definitions = <<TASK_DEFINITION
[
    {
        "cpu": ${var.staging_container_cpu},
        "image": "${var.staging_image_tag}",
        "memory": ${var.staging_container_memory},
        "name": "${var.staging_container_name}",
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
          "value":"postgresql://${var.staging_rds_user}:${var.staging_rds_pass}@${aws_db_instance.staging_rds.endpoint}/${var.staging_rds_db}"
        },
        {  
          "name":"URL_MEASUREMENTS",
          "value":"${var.url_measurements}"
        }]
    }
]
TASK_DEFINITION
  tags = {
    Environment = "staging"
  }
}

resource "aws_ecs_service" "staging_api" {
  name            = "measurement-app-staging"
  cluster         = aws_ecs_cluster.staging.id
  task_definition = aws_ecs_task_definition.staging_api.arn
  desired_count   = var.staging_container_count
  tags = {
    Environment = "staging"
  }
}
