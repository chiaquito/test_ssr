########## vpc attached to igw ##########

# there are api-server(ec2), nextjs-ssr-server(ec2) and rds in this vpc 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "nextjs_vpc"
    App  = "nextjs"
    Iac  = true
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "nextjs_igw"
    App  = "nextjs"
    Iac  = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "nextjs_rt"
    App  = "nextjs"
    Iac  = true
  }
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id

}

# public subnet for api-server and nextjs-ssr-server
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = aws_db_instance.rds_mysql.availability_zone

  tags = {
    Name = "nextjs_public_subnet"
    App  = "nextjs"
    Iac  = true
  }
}

# private subnets for rds
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "nextjs_private_subnet"
    App  = "nextjs"
    Iac  = true
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "nextjs_private_subnet"
    App  = "nextjs"
    Iac  = true
  }
}



########## security group ###########

# security group for rds
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "rds_sg" {
  name        = "ec2_rds_sg"
  description = "for rds: this sg allows api server to access rds server using port 3306"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_apiserver_sg.id] # EC2セキュリティグループからのアクセスを許可
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # 全プロトコル許可
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nextjs_rds_sg"
    App  = "nextjs"
    Iac  = true
  }
}

# security group for api-server
resource "aws_security_group" "ec2_apiserver_sg" {
  vpc_id      = aws_vpc.main.id
  description = "for ec2: this sg allows api server to recieve on port 1323"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1323
    to_port     = 1323
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "nextjs_ec2_apiserver_sg"
    App  = "nextjs"
    Iac  = true
  }
}

# security group for nextjs-ssr-server
resource "aws_security_group" "ec2_ssrserver_sg" {
  vpc_id      = aws_vpc.main.id
  description = "for ec2: this sg allows api server to recieve on port 3000"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "nextjs_ec2_ssrserver_sg"
    App  = "nextjs"
    Iac  = true
  }
}


###### elastic ip for CORS #######

# elastic ip attached to api-server(ec2) 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "eip" {
  instance = aws_instance.api_server.id
}
