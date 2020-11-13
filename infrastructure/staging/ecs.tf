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
          "hostPort": 0
        }],
        "environment":[{  
          "name":"FLASK_ENV",
          "value":"${var.flask_env}"
        },
        {  
          "name":"URL_MEASUREMENTS",
          "value":"${var.url_measurements}"
        }],
        "secrets": [{
          "name":"DB_URI",
          "valueFrom": "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter${aws_ssm_parameter.db_uri.name}"
        }]
    }
]
TASK_DEFINITION
  execution_role_arn    = aws_iam_role.ecs_task.arn
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_ecs_service" "api" {
  name            = "${var.environment}-measurement-app"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = var.container_count
  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = var.container_name
    container_port   = 5000
  }
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
        "command":["flask","initdb"],
        "environment":[{  
          "name":"FLASK_ENV",
          "value":"${var.flask_env}"
        },
        {  
          "name":"URL_MEASUREMENTS",
          "value":"${var.url_measurements}"
        }],
        "secrets": [{
          "name":"DB_URI",
          "valueFrom": "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter${aws_ssm_parameter.db_uri.name}"
        }]
    }
]
TASK_DEFINITION
  execution_role_arn    = aws_iam_role.ecs_task.arn
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

