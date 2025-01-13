# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
# resource "aws_db_instance" "ecs_task_definitionrds_mysql" {
#   identifier             = var.aws_db_instance_identifier
#   db_name                = var.aws_db_instance_identifier
#   allocated_storage      = 20
#   engine                 = "mysql"
#   engine_version         = "8.0.39"
#   instance_class         = "db.t4g.micro"
#   username               = var.aws_db_instance_username
#   password               = var.aws_db_instance_password
#   parameter_group_name   = "default.mysql8.0"
#   db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
#   vpc_security_group_ids = [aws_security_group.rds_sg.id]
#   storage_encrypted      = true
#   skip_final_snapshot    = true

#   tags = {
#     Name = "ecs_nextjs_rds_terraform"
#     App  = "nextjs"
#     Iac  = true
#   }
# }

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
# resource "aws_db_subnet_group" "subnet_group" {
#   name       = "db-subnet-group"
#   subnet_ids = [aws_subnet.shozai_private_subnet_main.id, aws_subnet.shozai_private_subnet_sub.id]

#   tags = {
#     Name = "ecs_nextjs_subnet_gp_terraform"
#     App  = "nextjs"
#     Iac  = true
#   }
# }