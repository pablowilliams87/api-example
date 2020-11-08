resource "aws_db_subnet_group" "development_rds" {
  name       = "development_rds"
  subnet_ids = aws_subnet.development_private.*.id
  tags = {
    Name        = "development_rds"
    Environment = "development"
  }
}

resource "aws_security_group" "development_rds" {
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
    description     = "Postgres Development"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.development_ecs.id]
  }
  tags = {
    Name        = "development_rds"
    Environment = "development"
  }
}

resource "aws_db_instance" "development_rds" {
  identifier             = "rds-development"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.8"
  instance_class         = var.development_rds_instancetype
  name                   = var.development_rds_db
  username               = var.development_rds_user
  password               = var.development_rds_pass
  db_subnet_group_name   = aws_db_subnet_group.development_rds.name
  parameter_group_name   = "default.postgres11"
  vpc_security_group_ids = [aws_security_group.development_rds.id]
  tags = {
    Name        = "development_rds"
    Environment = "development"
  }
}
