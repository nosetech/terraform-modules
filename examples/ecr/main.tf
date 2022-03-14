provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "api_ecr" {
  source = "git::https://github.com/nosetech/terraform-modules.git//modules/aws/ecr"

  name   = "api"
  tags   = {
    Name = "api"
  }
}