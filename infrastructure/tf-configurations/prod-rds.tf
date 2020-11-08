resource "aws_db_subnet_group" "production_rds" {
  name       = "production_rds"
  subnet_ids = aws_subnet.production_private.*.id
  tags = {
    Name        = "production_rds"
    Environment = "production"
  }
}

resource "aws_security_group" "production_rds" {
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
    description     = "Postgres production"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.production_ecs.id]
  }
  tags = {
    Name        = "production_rds"
    Environment = "production"
  }
}

resource "aws_db_instance" "production_rds" {
  identifier             = "rds-production"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.8"
  instance_class         = var.production_rds_instancetype
  name                   = var.production_rds_db
  username               = var.production_rds_user
  password               = var.production_rds_pass
  db_subnet_group_name   = aws_db_subnet_group.production_rds.name
  parameter_group_name   = "default.postgres11"
  vpc_security_group_ids = [aws_security_group.production_rds.id]
  tags = {
    Name        = "production_rds"
    Environment = "production"
  }
}
