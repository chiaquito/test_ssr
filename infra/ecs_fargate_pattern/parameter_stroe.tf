########################################################
#                  Parameter Store                     #
########################################################

# Database Connection Config for Api Server
resource "aws_ssm_parameter" "nextjs_database_host" {
  name  = "/nextjs/database/host"
  type  = "String"
  value = aws_db_instance.ecs_rds_mysql.address
}

resource "aws_ssm_parameter" "nextjs_database_port" {
  name  = "/nextjs/database/port"
  type  = "String"
  value = aws_db_instance.ecs_rds_mysql.port
}

resource "aws_ssm_parameter" "nextjs_database_name" {
  name  = "/nextjs/database/name"
  type  = "String"
  value = aws_db_instance.ecs_rds_mysql.name
}

resource "aws_ssm_parameter" "nextjs_database_username" {
  name  = "/nextjs/database/username"
  type  = "String"
  value = aws_db_instance.ecs_rds_mysql.username
}

resource "aws_ssm_parameter" "nextjs_database_password" {
  name  = "/nextjs/database/password"
  type  = "String"
  value = aws_db_instance.ecs_rds_mysql.password
}

# Api Server Connection Config for Nextjs SSR Server using ALB
resource "aws_ssm_parameter" "nextjs_apiserver_endpoint" {
  name        = "/nextjs/apiserver/host"
  type        = "String"
  value       = aws_lb.alb_for_apiservers.dns_name
  description = ""
}

resource "aws_ssm_parameter" "nextjs_apiserver_port" {
  name        = "/nextjs/apiserver/port"
  type        = "String"
  value       = 1323
  description = ""
}