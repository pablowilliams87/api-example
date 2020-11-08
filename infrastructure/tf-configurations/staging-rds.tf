resource "aws_db_subnet_group" "staging_rds" {
  name       = "staging_rds"
  subnet_ids = aws_subnet.staging_private.*.id
  tags = {
    Name        = "staging_rds"
    Environment = "staging"
  }
}

resource "aws_security_group" "staging_rds" {
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
    description     = "Postgres staging"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.staging_ecs.id]
  }
  tags = {
    Name        = "staging_rds"
    Environment = "staging"
  }
}

resource "aws_db_instance" "staging_rds" {
  identifier             = "rds-staging"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.8"
  instance_class         = var.staging_rds_instancetype
  name                   = var.staging_rds_db
  username               = var.staging_rds_user
  password               = var.staging_rds_pass
  db_subnet_group_name   = aws_db_subnet_group.staging_rds.name
  parameter_group_name   = "default.postgres11"
  vpc_security_group_ids = [aws_security_group.staging_rds.id]
  tags = {
    Name        = "staging_rds"
    Environment = "staging"
  }
}
