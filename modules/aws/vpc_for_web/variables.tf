variable aws_region {
  default = "ap-northeast-1"
}
variable cidr {
  default = "10.1.0.0/16"
}
variable subnet_bits {
  default = 8
}
variable public_subnet_num {
  default = 2
}
variable private_subnet_num {
  default = 2
}
variable availability_zones {
  default = ["ap-northeast-1a","ap-northeast-1c","ap-northeast-1d"]
}
variable default_nacl_rule {
  default = {
    ## [ rule_no, ingress=false/egress=true, protocol, action, cidr_blocks, from_port, to_port ]
    "out_1" = [100, true, -1, "allow", "0.0.0.0/0", 0, 0],
    "in_1" = [100, false, -1, "allow", "0.0.0.0/0", 0, 0],
  }
}
variable public_nacl_rule {
  default = {
    ## [ rule_no, ingress=false/egress=true, protocol, action, cidr_blocks, from_port, to_port ]
    "out_1" = [100, true, -1, "allow", "0.0.0.0/0", 0, 0],
    "in_1" = [100, false, "tcp", "allow", "0.0.0.0/0", 443, 443],
  }
}
variable private_nacl_rule {
  default = {
    ## [ rule_no, ingress=false/egress=true, protocol, action, cidr_blocks, from_port, to_port ]
    "out_1" = [100, true, -1, "allow", "0.0.0.0/0", 0, 0],
    "in_1" = [100, false, "tcp", "allow", "0.0.0.0/0", 443, 443],
    "in_2" = [200, false, "tcp", "allow", "0.0.0.0/0", 3036, 3036],
  }
}
variable default_sg{
  default = {
    ## [ type, from_port, to_port, protocol, sg-id, cidr_blocks, description ]
    "out_1" = ["egress", 0, 0, "-1", null, ["0.0.0.0/0"], "Allow any outbound traffic"]
    "in_1" = ["ingress", 0, 0, "-1", null, ["0.0.0.0/0"], "Allow any inbound traffic"],
  }
}
variable frontend_sg{
  default = {
    ## [ type, from_port, to_port, protocol, sg-id, cidr_blocks, description ]
    "out_1" = ["egress", 0, 0, "-1", null, ["0.0.0.0/0"], "Allow any outbound traffic"]
    "in_1" = ["ingress", 443, 443, "tcp", null, ["0.0.0.0/0"], "HTTPS from Internal"],
  }
}
variable backend_sg{
  default = {
    ## [ type, from_port, to_port, protocol, sg-id, cidr_blocks, description ]
    "out_1" = ["egress", 0, 0, "-1", null, ["0.0.0.0/0"], "Allow any outbound traffic"]
    "in_1" = ["ingress", 443, 443, "tcp", null, ["0.0.0.0/0"], "HTTPS from Internal"],
    "in_2" = ["ingress", 3306, 3306, "tcp", null, ["0.0.0.0/0"], "MySQL from Internal"],
  }
}
variable name_tag_prefix {
  default = ""
}