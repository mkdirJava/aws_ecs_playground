terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}
provider "aws" {
  region = "eu-west-2"
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = var.service.service_name
      image     = var.service.image
      cpu       = 10
      memory    = 256
      essential = true
      "environment": [
        {"name": "PORT", "value": tostring(var.service.port)}
      ],
      portMappings = [
        {
          containerPort = var.service.port
          hostPort      = var.service.port
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-2a,eu-west-2b,eu-west-2c]"
  }
}

module "app_ECS" {
  source = "./modules/ECS"
  ecs_port = var.service.port
}

module "app_ECS_service" {
  source = "./modules/ECS_service"
  ecs_cluster_id = module.app_ECS.ecs_cluster_id
  ecs_task_arn = aws_ecs_task_definition.task_definition.arn
  depends_on = [
    aws_ecs_task_definition.task_definition
  ]
}