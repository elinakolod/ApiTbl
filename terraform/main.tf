provider "aws" {
  version = "~> 2.21"
  region  = var.region
}

provider "template" {
  version = "~> 2.1"
}

terraform {
  backend "s3" {
    region  = "us-east-2"
    key     = "terraform/terraform.tfstate"
    encrypt = true
  }
}

module "global" {
  source       = "./environments/global"
  project_name = var.project_name
  profile = var.profile
}

module "staging" {
  source = "./environments/staging"

  region                            = var.region
  project_name                      = var.project_name
  profile                           = var.profile
  default_subnet_ids                = module.global.default_subnet_ids
  default_vpc_id                    = module.global.default_vpc_id
  ecs_instance_iam_role             = module.global.ecs_instance_iam_role
  ecs_instance_iam_instance_profile = module.global.ecs_instance_iam_instance_profile
  ecr_repositories                  = module.staging.ecr_repositories
}
