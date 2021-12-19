resource "aws_db_subnet_group" "co777-dbsub" {
  name        = var.db_sub_name
  description = var.db_sub_name
  subnet_ids  = var.subnet_mysql

  tags = {
    Name = "${var.tag_name}_dbsub"
  }
}

resource "aws_db_instance" "co777-Mysql" {
  allocated_storage      = var.storage_size
  storage_type           = var.storage_type
  engine                 = var.rds_engine
  engine_version         = var.rds_version
  instance_class         = var.db_class
  name                   = var.db_name
  identifier             = var.identifier
  username               = var.username
  password               = var.password
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.co777-dbsub.id
  vpc_security_group_ids = [var.security_Mysql_id]
  skip_final_snapshot    = true

  tags = {
    Name = "${var.tag_name}_Mysql"
  }
}
