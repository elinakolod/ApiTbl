# Task definition

data "template_file" "container_definitions" {
  template = file("${path.module}/templates/container_definitions.json")

  vars = {
    web_server_ecr_repo = var.ecr_repositories.web_server.repository_url
    server_app_ecr_repo = var.ecr_repositories.server_app.repository_url
    profile_name        = var.profile

    log_group  = aws_cloudwatch_log_group.this.name
    log_region = var.region
  }
}

resource "aws_ecs_task_definition" "this" {
  family       = local.project_name-environment
  network_mode = "bridge"
  cpu          = 896
  memory       = 896

  container_definitions = data.template_file.container_definitions.rendered

  volume {
    name = "redis"

    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
    }
  }

  volume {
    name = "postgres"

    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
    }
  }

  volume {
    name = "public"
  }
}

# Service

resource "aws_ecs_service" "this" {
  name                               = local.project_name-environment
  cluster                            = module.ecs_cluster.cluster.id
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  load_balancer {
    container_name = "web-server"
    container_port = 8080
    elb_name       = aws_elb.this.name
  }

  depends_on = [
    var.ecs_instance_iam_role,
    aws_elb.this
  ]
}
