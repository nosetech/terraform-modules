/***************************************************************************************************
 * VPC setting
***************************************************************************************************/
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.name_tag_prefix}-VPC"
  }
}

resource "aws_vpc_dhcp_options" "main_dhcp_option" {
  domain_name         = "${var.aws_region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  ntp_servers         = ["169.254.169.123"]

  tags = {
    Name = "${var.name_tag_prefix}-DHCPOptions"
  }
}

resource "aws_vpc_dhcp_options_association" "main_dhcp_option_association" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main_dhcp_option.id
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_tag_prefix}-IGW"
  }
} 

/***************************************************************************************************
 * Subnet setting
***************************************************************************************************/
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id

  count = var.public_subnet_num

  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, var.subnet_bits , count.index)

  tags = {
    Name = "${var.name_tag_prefix}-PublicSubnet-${count.index+1}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main.id

  count = var.private_subnet_num

  availability_zone = var.availability_zones[count.index]
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, var.subnet_bits , count.index+ length(aws_subnet.public_subnet))

  tags = {
    Name = "${var.name_tag_prefix}-PrivateSubnet-${count.index+1}"
  }
}

resource "aws_default_route_table" "public_RT" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.name_tag_prefix}-PublicRouteTable"
  }
}

resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_tag_prefix}-PrivateRouteTable"
  }
}

resource "aws_route_table_association" "private" {
  count = var.private_subnet_num

  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_RT.id
}

/***************************************************************************************************
 * NACL setting
***************************************************************************************************/
resource "aws_default_network_acl" "default_nacl" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  tags = {
    Name = "${var.name_tag_prefix}-DefaultSubnetNACL"
  }
}

resource "aws_network_acl_rule" "default_nacl_rule" {
  network_acl_id = aws_default_network_acl.default_nacl.id

  for_each       = var.default_nacl_rule
  rule_number    = each.value[0]
  egress         = each.value[1]
  protocol       = each.value[2]
  rule_action    = each.value[3]
  cidr_block     = each.value[4]
  from_port      = each.value[5]
  to_port        = each.value[6]
}

resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.main.id

  subnet_ids = aws_subnet.public_subnet.*.id

  tags = {
    Name = "${var.name_tag_prefix}-PublicSubnetNACL"
  }
}

resource "aws_network_acl_rule" "public_nacl_rule" {
  network_acl_id = aws_network_acl.public_nacl.id

  for_each       = var.public_nacl_rule
  rule_number    = each.value[0]
  egress         = each.value[1]
  protocol       = each.value[2]
  rule_action    = each.value[3]
  cidr_block     = each.value[4]
  from_port      = each.value[5]
  to_port        = each.value[6]
}

resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.main.id

  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name = "${var.name_tag_prefix}-PrivateSubnetNACL"
  }
}

resource "aws_network_acl_rule" "private_nacl_rule" {
  network_acl_id = aws_network_acl.private_nacl.id

  for_each       = var.private_nacl_rule
  rule_number    = each.value[0]
  egress         = each.value[1]
  protocol       = each.value[2]
  rule_action    = each.value[3]
  cidr_block     = each.value[4]
  from_port      = each.value[5]
  to_port        = each.value[6]
}

/***************************************************************************************************
 * SecurityGroup setting
***************************************************************************************************/
resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_tag_prefix}-DefaultSG"
  }
}
resource "aws_security_group_rule" "default_sg_rule" {
  security_group_id        = aws_default_security_group.default_sg.id
  for_each                 = var.default_sg
  type                     = each.value[0]
  from_port                = each.value[1]
  to_port                  = each.value[2]
  protocol                 = each.value[3]
  source_security_group_id = each.value[4]
  cidr_blocks              = each.value[5]
  description              = each.value[6]
}

resource "aws_security_group" "frontend_sg" {
  name        = "frontend_sg"
  description = "For Frontend Security Group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_tag_prefix}-FrontendSG"
  }
}
resource "aws_security_group_rule" "frontend_sg_rule" {
  security_group_id        = aws_security_group.frontend_sg.id
  for_each                 = var.frontend_sg
  type                     = each.value[0]
  from_port                = each.value[1]
  to_port                  = each.value[2]
  protocol                 = each.value[3]
  source_security_group_id = each.value[4]
  cidr_blocks              = each.value[5]
  description              = each.value[6]
}

resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "For Backend Security Group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_tag_prefix}-BackendSG"
  }
}
resource "aws_security_group_rule" "backend_sg_rule" {
  security_group_id        = aws_security_group.backend_sg.id
  for_each                 = var.backend_sg
  type                     = each.value[0]
  from_port                = each.value[1]
  to_port                  = each.value[2]
  protocol                 = each.value[3]
  source_security_group_id = each.value[4]
  cidr_blocks              = each.value[5]
  description              = each.value[6]
}