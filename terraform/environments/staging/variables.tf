variable "ecs_instance_iam_instance_profile" {
  description = "ECS instance IAM instance profile"
}

variable "ecs_instance_iam_role" {
  description = "ECS instance IAM role"
}

variable "default_subnet_ids" {
  description = "Subnet ids from default VPC"
}

variable "default_vpc_id" {
  description = "Default VPC id"
}

variable "region" {
  description = "AWS Region"
}

variable "project_name" {
  description = "Project name"
}

variable "ecr_repositories" {
  description = "Map of available repositories"
}

variable "profile" {
  description = "Profile name"
}
