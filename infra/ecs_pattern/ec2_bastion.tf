
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "bastion_host" {
  ami                         = var.aws_instance_ami # amazon linux 2023
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.shozai_public.id
  availability_zone           = aws_db_instance.ecs_rds_mysql.availability_zone
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_bastion_host_sg.id]
  user_data                   = file("setup_bastion_host.sh")
  key_name = data.aws_key_pair.key_pair.key_name

  tags = {
    Name = "nextjs_bastion_host_terraform"
    App  = "nextjs"
    Iac  = true
  }
}