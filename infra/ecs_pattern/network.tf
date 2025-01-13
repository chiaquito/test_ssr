# vpc
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

# # public subnet
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# resource "aws_subnet" "public" {
#   vpc_id            = aws_vpc.shozai_ecs_main.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = aws_db_instance.ecs_task_definitionrds_mysql.availability_zone

#   tags = {
#     Name = "nextjs_public_subnet"
#     App  = "nextjs"
#     Iac  = true
#   }
# }

# private subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "shozai_private_subnet_main" {
  vpc_id     = aws_vpc.shozai_ecs_main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "nextjs_ecs_private_subent_a_terraform"
    App  = "nextjs"
    Iac  = true
  }
}

# resource "aws_subnet" "shozai_private_subnet_c" {
#   vpc_id     = aws_vpc.shozai_ecs_main.id
#   cidr_block = "10.0.3.0/24"
#   availability_zone = "ap-northeast-1c"

#   tags = {
#     Name = "nextjs_ecs_private_subent_c_terraform"
#     App  = "nextjs"
#     Iac  = true
#   }
# }


# route table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.shozai_ecs_main.id

  tags = {
    Name = "nextjs_ecs_route_table_terraform"
    App  = "nextjs"
    Iac  = true
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.shozai_private_subnet_main.id
  route_table_id = aws_route_table.main.id
}

# resource "aws_route_table_association" "example" {
#   subnet_id      = aws_subnet.public.id
#   route_table_id = aws_route_table.main.id
# }

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.shozai_ecs_main.id

#   tags = {
#     Name = "nextjs_igw_ecs_igw_terraform"
#     App  = "nextjs"
#     Iac  = true
#   }
# }

# resource "aws_route" "igw_route" {
#   route_table_id         = aws_route_table.main.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.id

# }


resource "aws_vpc_endpoint_route_table_association" "s3" {
  vpc_endpoint_id = aws_vpc_endpoint.shozai_ecs_s3_gateway.id
  route_table_id  = aws_route_table.main.id
}



############### vpc endpoint ######################################################

# vpc endpoint / allows task to connect ECR using Docker Registry APIs
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html#ecr-setting-up-vpc-create
resource "aws_vpc_endpoint" "shozai_ecs_ecrdkr_vpcendpoint" {
  vpc_id              = aws_vpc.shozai_ecs_main.id
  service_name        = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.vpc_endpoint_sg.id,
  ]

  subnet_ids = [
    aws_subnet.shozai_private_subnet_main.id
  ]

  tags = {
    Name = "nextjs_ecs_ecrdkr_vpcendpoint_terraform"
    App  = "nextjs"
    Iac  = true
  }
}

# vpc endpoint / allows task to connect ECR using Amazon ECR API
resource "aws_vpc_endpoint" "shozai_ecs_ecrapi_vpcendpoint" {
  vpc_id              = aws_vpc.shozai_ecs_main.id
  service_name        = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true



  security_group_ids = [
    aws_security_group.vpc_endpoint_sg.id,
  ]

  subnet_ids = [
    aws_subnet.shozai_private_subnet_main.id
  ]

  tags = {
    Name = "nextjs_ecs_ecrapi_vpcendpoint_terraform"
    App  = "nextjs"
    Iac  = true
  }
}

resource "aws_vpc_endpoint" "shozai_ecs_logs_vpcendpoint" {
  vpc_id              = aws_vpc.shozai_ecs_main.id
  service_name        = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.shozai_private_subnet_main.id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

   tags = {
    Name = "nextjs_ecs_logs_vpcendpoint_terraform"
    App  = "nextjs"
    Iac  = true
  }
}


# s3-gateway
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html#ecr-setting-up-s3-gateway
resource "aws_vpc_endpoint" "shozai_ecs_s3_gateway" {
  vpc_id              = aws_vpc.shozai_ecs_main.id
  service_name        = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type   = "Gateway"
  private_dns_enabled = false
  route_table_ids     = [aws_route_table.main.id]
  policy              = <<POLICY
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Action": "*",
        "Effect": "Allow",
        "Resource": "*",
        "Principal": "*"
      }
    ]
  }
  POLICY

  tags = {
    Name = "nextjs_ecs_shozai_ecs_s3_gateway_terraform"
    App  = "nextjs"
    Iac  = true
  }
}




###################################################################

# security group for vpc endpoint
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "vpc_endpoint_sg" {
  vpc_id      = aws_vpc.shozai_ecs_main.id
  description = "for vpcendpoint: this sg opens port 443"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # 全プロトコル許可
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nextjs_vpc_endpoint_sg_terraform"
    App  = "nextjs"
    Iac  = true
  }
}

############################################################################

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
resource "aws_network_acl" "shozai_ecs_main" {
  vpc_id     = aws_vpc.shozai_ecs_main.id
  subnet_ids = [aws_subnet.shozai_private_subnet_main.id]

  ingress {
    rule_no    = 100
    action     = "allow"
    from_port  = 0           // 全てのポート
    to_port    = 0           // 全てのポート
    protocol   = "-1"        // -1は全てのプロトコル
    cidr_block = "0.0.0.0/0" // 許可するIP範囲
  }

  egress {
    rule_no    = 100
    action     = "allow"
    from_port  = 0           // 全てのポート
    to_port    = 0           // 全てのポート
    protocol   = "-1"        // -1は全てのプロトコル
    cidr_block = "0.0.0.0/0" // 許可するIP範囲
  }

  tags = {
    Name = "nextjs_network_acl_terraform"
    App  = "nextjs"
    Iac  = true
  }
}

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association
# resource "aws_network_acl_association" "main" {
#   network_acl_id = aws_network_acl.shozai_ecs_main.id
#   subnet_id      = aws_subnet.shozai_private_subnet_main.id
# }


