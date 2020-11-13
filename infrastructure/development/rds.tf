resource "aws_db_subnet_group" "rds" {
  name       = "${var.environment}-rds"
  subnet_ids = aws_subnet.private.*.id
  tags = {
    Name        = "${var.environment}_rds"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "rds" {
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
    description     = "Postgres ${var.environment}"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }
  tags = {
    Name        = "${var.environment}-rds"
    Environment = "${var.environment}"
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "${var.environment}-rds"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.8"
  instance_class         = var.rds_instancetype
  name                   = var.rds_db
  username               = var.rds_user
  password               = random_string.db_pass.result
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  parameter_group_name   = "default.postgres11"
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  tags = {
    Name        = "${var.environment}-rds"
    Environment = "${var.environment}"
  }
}
