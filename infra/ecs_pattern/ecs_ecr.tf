# ecr for api server
data "aws_ecr_repository" "ecs_api_server" {
  name = "ecs/testing"
}

