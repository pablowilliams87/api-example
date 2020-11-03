resource "null_resource" "previous" {}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [null_resource.previous]
  create_duration = "10s"
}

resource "aws_ecr_repository" "registry" {
  depends_on = [time_sleep.wait_10_seconds]
  name = "pablow-repository"
}