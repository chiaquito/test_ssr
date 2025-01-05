# there are acutual values in terraform.tfvars

variable "aws_db_instance_username" {
  description = "database authentication"
  type        = string
}
variable "aws_db_instance_password" {
  description = "database authentication"
  type        = string
}

variable "aws_db_instance_identifier" {
  type        = string
}

variable "aws_key_pair_key_name" {
  description = "ec2 authenticate key_name"
  type        = string
}

variable "aws_instance_ami" {
  description = "ec2, api-server and nextjs-ssr-server"
  type        = string
}

