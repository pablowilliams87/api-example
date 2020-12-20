resource "random_string" "db_pass" {
  length  = 12
  special = false
}

resource "aws_ssm_parameter" "db_uri" {
  name  = "/${var.environment}/db_uri"
  type  = "SecureString"
  value = "postgresql://${var.rds_user}:${random_string.db_pass.result}@${aws_db_instance.rds.endpoint}/${var.rds_db}"

  tags = {
    Environment = "${var.environment}"
  }
}
