# ECS cluster

resource "aws_ecs_cluster" "this" {
  name = var.name
}

# Autoscaling group

data "aws_ami" "ecs_optimized" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.20190709-x86_64-ebs"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    cluster_name = aws_ecs_cluster.this.name
    swap_size    = var.swap_size
  }
}

resource "aws_launch_template" "this" {
  name                   = var.name
  instance_type          = var.instance_type
  key_name               = var.key_pair.key_name
  vpc_security_group_ids = [var.cluster_instance_sg.id]
  image_id               = data.aws_ami.ecs_optimized.id
  user_data              = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = var.ecs_instance_iam_instance_profile.name
  }
}

resource "aws_autoscaling_group" "this" {
  name                 = var.name
  vpc_zone_identifier  = var.subnet_ids
  desired_capacity     = var.number_of_instances
  min_size             = 0
  max_size             = var.number_of_instances

  launch_template {
    id = aws_launch_template.this.id
  }
}
