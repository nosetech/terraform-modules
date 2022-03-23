provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "web_vpc" {
  source = "git::https://github.com/nosetech/terraform-modules.git//modules/aws/vpc_for_web"

  aws_region = var.aws_region
  cidr       = "10.1.0.0/16"

  subnet_bits = 8
  public_subnet_num = 2
  private_subnet_num = 2
  availability_zones = ["ap-northeast-1a","ap-northeast-1c"]

  public_nacl_rule  = {
    ## [ rule_no, ingress=false/egress=true, protocol, action, cidr_blocks, from_port, to_port ]
    "out_1" = [100, true, -1, "allow", "0.0.0.0/0", 0, 0],
    "in_2" = [100, false, "tcp", "allow", "0.0.0.0/0", 443, 443],
  }
  private_nacl_rule = {
    ## [ rule_no, ingress=false/egress=true, protocol, action, cidr_blocks, from_port, to_port ]
    "out_1" = [100, true, -1, "allow", "0.0.0.0/0", 0, 0],
    "in_2" = [100, false, "tcp", "allow", "0.0.0.0/0", 443, 443],
    "in_3" = [200, false, "tcp", "allow", "0.0.0.0/0", 3036, 3036],
  }

  frontend_sg = {
    ## [ type, from_port, to_port, protocol, sg-id, cidr_blocks, description ]
    "out_1" = ["egress", 0, 0, "-1", null, ["0.0.0.0/0"], "Allow any outbound traffic"]
    "in_1" = ["ingress", 443, 443, "tcp", null, ["0.0.0.0/0"], "HTTPS from Internal"],
  }
  backend_sg = {
    ## [ type, from_port, to_port, protocol, sg-id, cidr_blocks, description ]
    "out_1" = ["egress", 0, 0, "-1", null, ["0.0.0.0/0"], "Allow any outbound traffic"]
    "in_1" = ["ingress", 443, 443, "tcp", null, ["0.0.0.0/0"], "HTTPS from Internal"],
    "in_2" = ["ingress", 3306, 3306, "tcp", null, ["0.0.0.0/0"], "MySQL from Internal"],
  }
  name_tag_prefix = "example"
}