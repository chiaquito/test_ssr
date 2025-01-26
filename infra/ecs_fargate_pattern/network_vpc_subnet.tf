#################################################################
#                          vpc                                  #
#################################################################

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "shozai_ecs_main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "nextjs_ecs_vpc_terraform"
    App  = "nextjs"
    Iac  = true
  }
}


#################################################################
#                        subnet                                 #
#################################################################


////         Public Subnet        ////
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "shozai_public" {
  vpc_id            = aws_vpc.shozai_ecs_main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = aws_db_instance.ecs_rds_mysql.availability_zone

  tags = {
    Name = "nextjs_public_subnet"
    App  = "nextjs"
    Iac  = true
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  excluded_az = aws_db_instance.ecs_rds_mysql.availability_zone
  target_azs  = [for az in data.aws_availability_zones.available.names : az if az != local.excluded_az]
}

resource "aws_subnet" "shozai_public_sub" {
  vpc_id            = aws_vpc.shozai_ecs_main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = local.target_azs[0]

  tags = {
    Name = "nextjs_public_subnet_left_availability_zone"
    App  = "nextjs"
    Iac  = true
  }
}


# private subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "shozai_private_subnet_a" {
  vpc_id            = aws_vpc.shozai_ecs_main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "nextjs_ecs_private_subent_a_terraform"
    App  = "nextjs"
    Iac  = true
  }
}

resource "aws_subnet" "shozai_private_subnet_c" {
  vpc_id            = aws_vpc.shozai_ecs_main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "nextjs_ecs_private_subent_c_terraform"
    App  = "nextjs"
    Iac  = true
  }
}
