# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "rds_mysql" {
  allocated_storage = 20
  # db_name              = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0.39"
  instance_class         = "db.t4g.micro"
  username               = var.aws_db_instance_username
  password               = var.aws_db_instance_password
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  storage_encrypted      = true
  skip_final_snapshot    = true

  tags = {
    Name = "nextjs_rds"
    App  = "nextjs"
    Iac  = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_c.id]

  tags = {
    Name = "nextjs_subnet_gp"
    App  = "nextjs"
    Iac  = true
  }
}