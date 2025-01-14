############################################################
#                      Route Table                         #
############################################################


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.shozai_ecs_main.id

  tags = {
    Name = "nextjs_ecs_route_table_terraform"
    App  = "nextjs"
    Iac  = true
  }
}


###############################################################
#                    Route and Association                    #
###############################################################


resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "igw_route_association" {
  subnet_id      = aws_subnet.shozai_public.id
  route_table_id = aws_route_table.main.id
}


////////////////////////////////////////////////////////////

# S3へのGateway用...確か
resource "aws_route_table_association" "main_a" {
  subnet_id      = aws_subnet.shozai_private_subnet_a.id
  route_table_id = aws_route_table.main.id
}

# S3へのGateway用...確か
resource "aws_route_table_association" "main_c" {
  subnet_id      = aws_subnet.shozai_private_subnet_c.id
  route_table_id = aws_route_table.main.id
}


resource "aws_vpc_endpoint_route_table_association" "s3" {
  vpc_endpoint_id = aws_vpc_endpoint.shozai_ecs_s3_gateway.id
  route_table_id  = aws_route_table.main.id
}









###############################################################
#                     Internet Gateway                        #
###############################################################

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.shozai_ecs_main.id

  tags = {
    Name = "nextjs_igw_ecs_igw_terraform"
    App  = "nextjs"
    Iac  = true
  }
}

