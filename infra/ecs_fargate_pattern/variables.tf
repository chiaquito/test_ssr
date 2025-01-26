# there are acutual values in terraform.tfvars

###########################################
#            Database Variables           #
###########################################

//   Variables for Database Connection  //

# variable "aws_db_instance_host" {
#   type        = string  
# }
# これは変数で定義するのではなく、rdsインスタンスのプロパティをパラメータストアに入れればよいから不要？

variable "aws_db_instance_port" {
  description = "database authentication"
  type        = string
}

# variable "aws_db_instance_name" {
#   description = "database authentication"
#   type        = string
# }

variable "aws_db_instance_username" {
  description = "database authentication"
  type        = string
}

variable "aws_db_instance_password" {
  description = "database authentication"
  type        = string
}


//  Variables for Creating Database Resource  //
variable "aws_db_instance_identifier" {
  description = "database authentication"
  type        = string
}

variable "aws_db_instance_engine_version" {
  description = "database version"
  type        = string
}



###################################################
#            EC2 Bastion Host Variables           #
###################################################

//   Variables for Creating EC2 Bation Host  //
variable "aws_key_pair_key_name" {
  type        = string
  description = "Name of Key Pair to use for SSH"
}

variable "aws_instance_ami" {
  type        = string
  description = "AMI for EC2 Bastion Host"
}


###################################################
#                 ECR Variables                   #
###################################################

# ECR Name for Api Server
variable "aws_ecr_repository_api_server_name" {
  type        = string
  description = "Name of ECR for Api Server"
}

# ECR Name for Next.js SSR Server
variable "aws_ecr_repository_ssr_server_name" {
  type        = string
  description = "Name of ECR for Nextjs SSR Server"
}
