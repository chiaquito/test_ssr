# ssh認証用鍵
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/key_pair
data "aws_key_pair" "key_pair" {
  key_name = var.aws_key_pair_key_name
  # key_pair_id        = "key-08be3c43633fe2d6f"
  include_public_key = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#associate_public_ip_address-1
resource "aws_instance" "api_server" {
  ami           = "ami-0ab02459752898a60" # amazon linux 2023
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public.id

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = file("setup_api_server.sh")
  key_name               = data.aws_key_pair.key_pair.key_name

  tags = {
    Name = "nextjs_api_server"
    App  = "nextjs"
    Iac  = true
  }
}

