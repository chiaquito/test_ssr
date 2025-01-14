# ECR for Api Server
data "aws_ecr_repository" "ecs_api_server" {
  name = var.aws_ecr_repository_api_server_name
}

# ECR for Next.js SSR Server
data "aws_ecr_repository" "ecs_nextjs_server" {
  name = var.aws_ecr_repository_ssr_server_name
}