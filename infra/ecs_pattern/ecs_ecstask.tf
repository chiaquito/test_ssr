##################################################################
#                     ECS Task Definition                        #
##################################################################


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "tf_task_definiton" {
  family = "ecs_task_difinition_by_terraform"
  # https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html
  container_definitions    = file("./ecs_containerdefinitions/api_server.json")
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name = "nextjs_ecs_task_definition"
    App  = "nextjs"
    Iac  = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "tf_task_definiton_nextjs" {
  family = "ecs_task_difinition_by_terraform_nextjs_sever"
  # https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html
  container_definitions    = file("./ecs_containerdefinitions/nextjs_server.json")
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name = "nextjs_ecs_task_definition_nextjs_server"
    App  = "nextjs"
    Iac  = true
  }
}


############################################################################
#                      IAM Role / Task Role                                #
############################################################################


resource "aws_iam_role" "ecs_task_role" {
  description = "A task IAM role allows containers in the task to make API requests to AWS services."
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ]

  name = "ecsAmazonEC2ContainerRegistryReadOnlyTerraform"
  path = "/"

  tags = {
    Name = "nextjs_ecs_task_role_terraform"
    App  = "nextjs"
    Iac  = true
  }
}




############################################################################
#                      IAM Role / Task Execution Role                      #
############################################################################


resource "aws_iam_role" "ecs_task_execution_role" {
  description = "A task execution IAM role is used by the container agent to make AWS API requests on your behalf."
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]

  name = "ecsTaskExecutionRoleTerraform"
  path = "/"

  tags = {
    Name = "nextjs_ecs_task_execution_role_terraform"
    App  = "nextjs"
    Iac  = true
  }
}
