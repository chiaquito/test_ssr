# ecs cluster
resource "aws_ecs_cluster" "shozai_cluster" {
  name = "shozai-ecs-cluster"

  tags = {
    Name = "nextjs_ecs_cluster"
    App  = "nextjs"
    Iac  = true
  }
}

# data plane
resource "aws_ecs_cluster_capacity_providers" "provider" {
  cluster_name       = aws_ecs_cluster.shozai_cluster.name
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
}

