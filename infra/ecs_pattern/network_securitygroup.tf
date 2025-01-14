############################################################################
#                      Security group                                      #
############################################################################

# 1.Security group for vpc endpoint
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "vpc_endpoint_sg" {
  vpc_id      = aws_vpc.shozai_ecs_main.id
  description = "this sg opens port 443 for vpc endpoint, for tasks pulling image from ECR and awslogs sending logs to cloudwatch"

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

# 2.Configuring the security group for the Application Load Balancer to allow ingress from the internet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Configuring the security group for the Application Load Balancer to allow ingress from the internet, HTTP and HTTPS"
  vpc_id      = aws_vpc.shozai_ecs_main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "nextjs_alb_sg_terraform"
    App  = "nextjs"
    Iac  = true
  }
}


# 3.Security group to open 1323 number for api server
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "apiserver_sg" {
  name        = "apiserver_sg"
  description = "Security group to open 1323 port for Api Server"
  vpc_id      = aws_vpc.shozai_ecs_main.id


  # Allows the Nextjs SSR servers, which located in the public subnet, to send requests to port 1323
  ingress {
    from_port   = 1323
    to_port     = 1323
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"] # public subnet 
  }

  # Allows the EC2 Bastion Host to send requests to port 1323
  ingress {
    from_port       = 1323
    to_port         = 1323
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id, aws_security_group.ec2_bastion_host_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # 全プロトコル許可
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nextjs_apiserver_sg_terraform"
    App  = "nextjs"
    Iac  = true
  }
}


# 4.Configuring the security group to open port 3306 so that ECS tasks and EC2 bastion host can send requests to RDS
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Configuring the security group to open port 3306 so that ECS tasks and EC2 bastion host can send requests to RDS"
  vpc_id      = aws_vpc.shozai_ecs_main.id

  # open 3306 for ECS tasks and the EC2 Bastion Host
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.apiserver_sg.id, aws_security_group.ec2_bastion_host_sg.id]
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



# 5.Configuring the security group to open port 22 so that EC2 Bastion Host can recieve requests from clients
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "ec2_bastion_host_sg" {
  name        = "ec2_bastion_host_sg"
  description = "Configuring the security group to open port 22 so that EC2 Bastion Host can recieve requests from clients"
  vpc_id      = aws_vpc.shozai_ecs_main.id

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
    Name = "nextjs_ecs_bastion_host_sg"
    App  = "nextjs"
    Iac  = true
  }
}

