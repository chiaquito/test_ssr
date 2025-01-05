# ec2 for nextjs-ssr-server

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#associate_public_ip_address-1
resource "aws_instance" "nextjs_ssr_server" {
  ami                         = var.aws_instance_ami # amazon linux 2023
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  availability_zone           = aws_db_instance.rds_mysql.availability_zone
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_ssrserver_sg.id]
  user_data                   = file("setup_nextjs_ssr_server.sh")
  key_name                    = data.aws_key_pair.key_pair.key_name

  tags = {
    Name = "nextjs_ssr_server"
    App  = "nextjs"
    Iac  = true
  }
}

