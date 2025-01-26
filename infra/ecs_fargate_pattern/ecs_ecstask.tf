##################################################################
#                     ECS Task Definition                        #
##################################################################

// Api Server Task
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "tf_task_definiton_api" {
  family = "ecs_task_difinition_by_terraform"
  # https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      "name" : "ecs_api_server",
      "image" : "938768818671.dkr.ecr.ap-northeast-1.amazonaws.com/ecs/testing:latest",
      "cpu" : 256,
      "essential" : true,
      "memory" : 512,
      "portMappings" : [
        {
          "containerPort" : 1323,
          "hostPort" : 1323
        }
      ],
      "secrets" : [
        {
          "name" : "DB_HOST",
          "valueFrom" : "/nextjs/database/host"
        },
        {
          "name" : "DB_NAME",
          "valueFrom" : "/nextjs/database/name"
        },
        {
          "name" : "DB_PORT",
          "valueFrom" : "/nextjs/database/port"
        },
        {
          "name" : "DB_USER",
          "valueFrom" : "/nextjs/database/username"
        },
        {
          "name" : "DB_PASSWORD",
          "valueFrom" : "/nextjs/database/password"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/delete_plan",
          "mode" : "blocking",
          "awslogs-create-group" : "true",
          "max-buffer-size" : "25m",
          "awslogs-region" : "ap-northeast-1",
          "awslogs-stream-prefix" : "ecs"
        },
        "secretOptions" : []
      }
    }
  ])
  tags = {
    Name = "nextjs_ecs_task_definition_api_server"
    App  = "nextjs"
    Iac  = true
  }
}

// Nextjs SSR Task
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "tf_task_definiton_nextjs" {
  family = "ecs_task_difinition_by_terraform_nextjs_sever"
  # https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      "name" : "ecs_nextjs_server",
      "image" : "938768818671.dkr.ecr.ap-northeast-1.amazonaws.com/ecs/nextjs:latest",
      "cpu" : 256,
      "essential" : true,
      "memory" : 512,
      "portMappings" : [
        {
          "containerPort" : 3000,
          "hostPort" : 3000
        }
      ],
      "secrets": [
        {
          "name": "API_SERVER_HOST",
          "valueFrom" : "/nextjs/apiserver/host"
        },
        {
          "name": "API_SERVER_PORT",
          "valueFrom" : "/nextjs/apiserver/port"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/delete_plan",
          "mode" : "blocking",
          "awslogs-create-group" : "true",
          "max-buffer-size" : "25m",
          "awslogs-region" : "ap-northeast-1",
          "awslogs-stream-prefix" : "ecs"
        },
        "secretOptions" : []
      }
    }
  ])
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

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_ssm_access_policy.arn
}

// An IAM Policy Allows Values From Parameter Store  
resource "aws_iam_policy" "ecs_task_ssm_access_policy" {
  name = "ecs-task-ssm-access-policy"
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ssm:GetParameters",
            "ssm:GetParameter"
          ]
          # needs access control
          Resource = "arn:aws:ssm:ap-northeast-1:*:parameter/nextjs/*"
        }
      ]
    }
  )
}





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





################################################################
#                           Service                            #        
################################################################

# Nextjs Tasks
resource "aws_ecs_service" "example_nextjs" {
  name            = "nextjs_service"
  cluster         = aws_ecs_cluster.shozai_cluster.id
  task_definition = aws_ecs_task_definition.tf_task_definiton_nextjs.arn
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.shozai_public.id]
    security_groups  = [aws_security_group.nextjsserver_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nextjs_lb_target_group.arn
    container_name   = "ecs_nextjs_server" # jsonで定めたcontainer_name
    container_port   = 3000
  }

  # launch_type = "FARGATE"
  capacity_provider_strategy {

    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }
}


# Api Server Tasks
resource "aws_ecs_service" "apiserver_service" {
  name            = "apiserver_service"
  cluster         = aws_ecs_cluster.shozai_cluster.id
  task_definition = aws_ecs_task_definition.tf_task_definiton_api.arn
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.shozai_private_subnet_c.id]
    security_groups = [aws_security_group.apiserver_sg.id]
    # assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.apiserver_tg.arn
    container_name   = "ecs_api_server" # jsonで定めたcontainer_name
    container_port   = 1323
  }

  # launch_type = "FARGATE"
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }
}

