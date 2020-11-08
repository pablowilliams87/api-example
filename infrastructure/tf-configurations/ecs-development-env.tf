resource "aws_ecs_cluster" "development" {
  name = var.development_ecs_cluster
}

resource "aws_ecs_task_definition" "development_api" {
  family                = "measurement-app-dev"
  container_definitions = <<TASK_DEFINITION
[
    {
        "cpu": 2,
        "image": "nginx:1.18.0",
        "memory": 256,
        "name": "measurement-app-dev",
        "portMappings": [{
          "containerPort": 80,
          "hostPort": 5000
        }]
    }
]
TASK_DEFINITION
}

resource "aws_ecs_service" "development_api" {
  name            = "measurement-app-dev"
  cluster         = aws_ecs_cluster.development.id
  task_definition = aws_ecs_task_definition.development_api.arn
  desired_count   = 1
}
