resource "aws_ecr_repository" "registry" {
  name = "${var.environment}-registry"
}