provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "dns" {
  source           = "git::https://github.com/nosetech/terraform-modules.git//modules/aws/route53_with_cert"

  domain_name      = var.domain_name
  hostedzone_tags  = {
    Name = "hostedzone"
  }

  cert_domain_name = var.cert_domain_name
  cert_tags        = {
    Name = "cert"
  }
}
