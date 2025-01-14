# there are acutual values in terraform.tfvars

variable "aws_db_instance_identifier" {
  description = "database authentication"
  type        = string
}

variable "aws_db_instance_engine_version" {
  description = "database version"
  type        = string
}

variable "aws_db_instance_username" {
  description = "database authentication"
  type        = string
}

variable "aws_db_instance_password" {
  description = "database authentication"
  type        = string
}

variable "aws_key_pair_key_name" {
  description = "ec2 authenticate key_name"
  type        = string
}

variable "aws_instance_ami" {
  description = "ec2 for bastion host"
  type        = string
}


# ECR for Api Server
variable "aws_ecr_repository_api_server_name" {
  description = "ECR for Api Server"
  type        = string
}

# ECR for Next.js SSR Server
variable "aws_ecr_repository_ssr_server_name" {
  description = "ECR for Next.js SSR Server"
  type        = string
}
