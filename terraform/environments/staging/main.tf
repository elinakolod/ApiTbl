locals {
  environment = "staging"
  project_name-environment = "${var.project_name}-staging"
}

module "ecs_cluster" {
  source = "../../modules/ecs_cluster"

  name                              = local.project_name-environment
  key_pair                          = aws_key_pair.this
  subnet_ids                        = var.default_subnet_ids
  cluster_instance_sg               = aws_security_group.cluster_instance
  ecs_instance_iam_instance_profile = var.ecs_instance_iam_instance_profile
}
