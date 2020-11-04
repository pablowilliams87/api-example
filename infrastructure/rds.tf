# Staging
resource "aws_db_subnet_group" "db-subnet-group-staging" {
  name       = "db-subnet-group-staging"
  subnet_ids = [aws_subnet.ecs-subnet-staging-1.id, aws_subnet.ecs-subnet-staging-2.id]
  tags = {
    Name = "DB Staging Subnet Group"
  }
}

resource "aws_security_group" "security-group-ecs-rds-staging" {
  description = "Allow ECS traffic to RDS Staging"
  vpc_id      = aws_vpc.custom-vpc.id
  ingress {
    description = "Postgres Staging subnet 1"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.ecs-subnet-staging-1.cidr_block]
  }
  ingress {
    description = "Postgres Staging subnet 2"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.ecs-subnet-staging-2.cidr_block]
  }
  tags = {
    Name = "Allow ECS traffic to RDS Staging"
  }
}

resource "aws_db_instance" "rds-staging" {
  identifier             = "rds-staging"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.8"
  instance_class         = var.postgres-staging-instancetype
  name                   = var.postgres-staging-dbname
  username               = var.postgres-staging-dbusername
  password               = var.postgres-staging-dbpassword
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group-staging.name
  parameter_group_name   = "default.postgres11"
  vpc_security_group_ids = [aws_security_group.security-group-ecs-rds-staging.id]
}



# Production
resource "aws_db_subnet_group" "db-subnet-group-production" {
  name       = "db-subnet-group-production"
  subnet_ids = [aws_subnet.ecs-subnet-production-1.id, aws_subnet.ecs-subnet-production-2.id]
  tags = {
    Name = "DB Production Subnet Group"
  }
}

resource "aws_security_group" "security-group-ecs-rds-production" {
  description = "Allow ECS traffic to RDS Production"
  vpc_id      = aws_vpc.custom-vpc.id
  ingress {
    description = "Postgres Production subnet 1"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.ecs-subnet-production-1.cidr_block]
  }
  ingress {
    description = "Postgres Production subnet 2"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.ecs-subnet-production-2.cidr_block]
  }
  tags = {
    Name = "Allow ECS traffic to RDS Production"
  }
}

/*
resource "aws_db_instance" "rds-production" {
  identifier             = "rds-production"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.8"
  instance_class         = var.postgres-production-instancetype
  name                   = var.postgres-production-dbname
  username               = var.postgres-production-dbusername
  password               = var.postgres-production-dbpassword
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group-production.name
  parameter_group_name   = "default.postgres11"
  vpc_security_group_ids = [aws_security_group.security-group-ecs-rds-production.id]
}
*/

resource "aws_rds_cluster_instance" "rds-production-cluster-instances" {
  count                = var.postgres-production-instances
  identifier           = "rds-production-${count.index}"
  cluster_identifier   = aws_rds_cluster.rds-production-cluster.id
  instance_class       = var.postgres-production-instancetype
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group-production.name
  engine               = "aurora-postgresql"
  engine_version       = "11.8"
}

resource "aws_rds_cluster" "rds-production-cluster" {
  cluster_identifier     = "rds-production-cluster"
  availability_zones     = [var.availability-zone-1, var.availability-zone-2]
  vpc_security_group_ids = [aws_security_group.security-group-ecs-rds-production.id]
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group-production.name
  database_name          = var.postgres-production-dbname
  master_username        = var.postgres-production-dbusername
  master_password        = var.postgres-production-dbpassword
  engine                 = "aurora-postgresql"
  engine_version         = "11.8"
  skip_final_snapshot    = true
}