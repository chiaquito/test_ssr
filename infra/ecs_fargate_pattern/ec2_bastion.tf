
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "bastion_host" {
  ami                         = var.aws_instance_ami # amazon linux 2023
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.shozai_public.id
  availability_zone           = aws_db_instance.ecs_rds_mysql.availability_zone
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_bastion_host_sg.id]
  user_data                   = file("setup_bastion_host.sh")
  key_name                    = data.aws_key_pair.key_pair.key_name

  tags = {
    Name = "nextjs_bastion_host_terraform"
    App  = "nextjs"
    Iac  = true
  }
}


##################################################
#          Application Load Balancer             #
##################################################

# ALB for Nextjs SSR Servers
resource "aws_lb" "nextjs_lb" {
  name                       = "ecs-nextjs-alb"
  internal                   = false
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = [aws_subnet.shozai_public.id, aws_subnet.shozai_public_sub.id]
  enable_deletion_protection = false

  tags = {
    Name = "nextjs_alb_for_nextjsserver_terraform"
    App  = "nextjs"
    Iac  = true
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.nextjs_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nextjs_lb_target_group.arn
  }
}

resource "aws_lb_target_group" "nextjs_lb_target_group" {
  name        = "nextjs-tg"
  port        = 3000 # Next.jsタスクがリッスンするポート
  protocol    = "HTTP"
  target_type = "ip" # awsvpcモードでは 'ip' を使用
  vpc_id      = aws_vpc.shozai_ecs_main.id

  health_check {
    path                = "/" # Next.jsでヘルスチェックのエンドポイントを設定
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "nextjs_alb_for_nextjsserver_alb_terraform"
    App  = "nextjs"
    Iac  = true
  }
}



# ALB for Api Servers from Nextjs SSR Servers
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb
resource "aws_lb" "alb_for_apiservers" {
  name = "ecs-alb-for-apiservers"
  // if internal is true, the Scheme will be Internal. if false, the Scheme will be Internet-facing.
  internal        = false
  security_groups = [aws_security_group.ecs_apiserver_alb_sg.id]
  subnets         = [aws_subnet.shozai_private_subnet_c.id, aws_subnet.shozai_private_subnet_a.id]

  enable_deletion_protection = false

  tags = {
    Name = "nextjs_alb_for_nextjsserver_terraform"
    App  = "nextjs"
    Iac  = true
  }
}

resource "aws_lb_listener" "apiserver" {
  load_balancer_arn = aws_lb.alb_for_apiservers.arn
  port              = 1323
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apiserver_tg.arn
  }
}


resource "aws_lb_target_group" "apiserver_tg" {
  name        = "nextjs-apiserver-tg"
  port        = 1323 # Api serverタスクがリッスンするポート
  protocol    = "HTTP"
  target_type = "ip" # awsvpcモードでは 'ip' を使用
  vpc_id      = aws_vpc.shozai_ecs_main.id

  health_check {
    path                = "/api/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "nextjs_alb_for_apiserver_alb_terraform"
    App  = "nextjs"
    Iac  = true
  }
}






# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
# resource "aws_lb" "test" {
#   name               = "aws_lb_test"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = [for subnet in aws_subnet.public : subnet.id]

#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

#   tags = {
#     Environment = "production"
#   }
# }