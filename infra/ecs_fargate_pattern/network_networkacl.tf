
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
resource "aws_network_acl" "shozai_ecs_main" {
  vpc_id     = aws_vpc.shozai_ecs_main.id
  subnet_ids = [aws_subnet.shozai_private_subnet_a.id, aws_subnet.shozai_private_subnet_c.id, aws_subnet.shozai_public.id]

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

