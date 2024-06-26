resource "aws_db_subnet_group" "db" {
  name       = "db"
  subnet_ids = module.vpc.database_subnets
  # indentifier = mysql_db

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds"
  description = "Allow inbound traffic for db tier"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group_rule" "rds" {
  security_group_id = aws_security_group.rds.id

  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app.id
}

resource "aws_db_instance" "main" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  db_name                = "mysql_db"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az = false # change to true to enable multi-az

  # To ensure the primary instance is in us-east-1a, specify its availability zone
  availability_zone = "us-east-1a"

  backup_retention_period = 7
  skip_final_snapshot     = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}