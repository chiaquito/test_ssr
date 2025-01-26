######################################################################
#                         vpc endpoint                               #
######################################################################

////       vpc endpoint / Interface       ////

# vpc endpoint / allows task to connect ECR using Docker Registry APIs
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html#ecr-setting-up-vpc-create
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint
resource "aws_vpc_endpoint" "shozai_ecs_ecrdkr_vpcendpoint" {
  vpc_id              = aws_vpc.shozai_ecs_main.id
  service_name        = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.vpc_endpoint_sg.id,
  ]

  subnet_ids = [
    aws_subnet.shozai_private_subnet_a.id,
    aws_subnet.shozai_private_subnet_c.id
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
    aws_subnet.shozai_private_subnet_a.id,
    aws_subnet.shozai_private_subnet_c.id
  ]

  tags = {
    Name = "nextjs_ecs_ecrapi_vpcendpoint_terraform"
    App  = "nextjs"
    Iac  = true
  }
}

resource "aws_vpc_endpoint" "shozai_ecs_logs_vpcendpoint" {
  vpc_id            = aws_vpc.shozai_ecs_main.id
  service_name      = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.shozai_private_subnet_a.id,
    aws_subnet.shozai_private_subnet_c.id
  ]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "nextjs_ecs_logs_vpcendpoint_terraform"
    App  = "nextjs"
    Iac  = true
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.shozai_ecs_main.id
  service_name      = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.shozai_private_subnet_a.id,
    aws_subnet.shozai_private_subnet_c.id,
  ]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "nextjs_ecs_ssm_vpcendpoint_terraform"
    App  = "nextjs"
    Iac  = true
  }
}





resource "aws_vpc_endpoint" "ssm2" {
  vpc_id            = aws_vpc.shozai_ecs_main.id
  service_name      = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.shozai_public.id,
    aws_subnet.shozai_public_sub.id
    # 追加


  ]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  // private_dns_enabled = true

  tags = {
    Name = "nextjs_ecs_ssm_vpcendpoint2_terraform"
    App  = "nextjs"
    Iac  = true
  }
}





////         vpc endpoint / Gateway          ////

# s3-gateway
# https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html#ecr-setting-up-s3-gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint
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
