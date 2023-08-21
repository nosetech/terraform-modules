# Description

このモジュールでは、基本的な Web システム向け(フロントエンド、バックエンド、DB)に AWS VPC のネットワーク環境を作成します。

# Usage

モジュールの使用例です。

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

# Requirements

前提とする Terraform,プロバイダーは以下のとおりです。

| Name      | Version   |
| :-------- | :-------- |
| terraform | >= 1.5.0  |
| aws       | >= 5.13.0 |

# Resources

作成されるリソースは以下のとおりです。

| Name                                                          | Type     |
| :------------------------------------------------------------ | :------- |
| aws_vpc.main                                                  | resource |
| aws_vpc_dhcp_options.main_dhcp_option                         | resource |
| aws_vpc_dhcp_options_association.main_dhcp_option_association | resource |
| aws_internet_gateway.main_igw                                 | resource |
| aws_subnet.public_subnet                                      | resource |
| aws_subnet.private_subnet                                     | resource |
| aws_default_route_table.public_RT                             | resource |
| aws_route_table.private_RT                                    | resource |
| aws_route_table_association.private                           | resource |
| aws_default_network_acl.public_nacl                           | resource |
| aws_network_acl_rule.public_nacl_rule                         | resource |
| aws_network_acl.private_nacl                                  | resource |
| aws_network_acl_rule.private_nacl_rule                        | resource |
| aws_default_security_group.main                               | resource |
| aws_security_group_rule.main_sg_rule                          | resource |
| aws_security_group.frontend_sg                                | resource |
| aws_security_group_rule.frontend_sg_rule                      | resource |
| aws_security_group.backend_sg                                 | resource |
| aws_security_group_rule.backend_sg_rule                       | resource |

# Inputs

指定できる引数は以下のとおりです。

| Name               | Description                          | Require | Default                                                                                                                                                                                                                               |
| :----------------- | :----------------------------------- | :------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| aws_region         | AWS リージョン                       | Option  | "ap-northeast-1"                                                                                                                                                                                                                      |
| cidr               | VPC の CIDR                          | Option  | "10.1.0.0/16"                                                                                                                                                                                                                         |
| subnet_bits        | subnet 用のネットワーク部拡張 bit    | Option  | 8                                                                                                                                                                                                                                     |
| public_subnet_num  | 作成するパブリックサブネットの数     | Option  | 2                                                                                                                                                                                                                                     |
| private_subnet_num | 作成するプライベートサブネットの数   | Option  | 2                                                                                                                                                                                                                                     |
| availability_zones | サブネットに適用する AZ              | Option  | "ap-northeast-1a","ap-northeast-1c","ap-northeast-1d"                                                                                                                                                                                 |
| public_nacl_rule   | パブリックサブネットの NACL          | Option  | [100, true, -1, "allow", "0.0.0.0/0", 0, 0],<br>[100, false, "tcp", "allow", "0.0.0.0/0", 443, 443]                                                                                                                                   |
| private_nacl_rule  | プライベートサブネットの NACL        | Option  | [100, true, -1, "allow", "0.0.0.0/0", 0, 0],<br>[100, false, "tcp", "allow", "0.0.0.0/0", 443, 443],<br>[200, false, "tcp", "allow", "0.0.0.0/0", 3036, 3036]                                                                         |
| frontend_sg        | フロントエンド用セキュリティグループ | Option  | ["egress", 0, 0, "-1", null, ["0.0.0.0/0"], "Allow any outbound traffic"],<br>["ingress", 443, 443, "tcp", null, ["0.0.0.0/0"], "HTTPS from Internal"]                                                                                |
| backend_sg         | バックエンド用セキュリティグループ   | Option  | ["egress", 0, 0, "-1", null, ["0.0.0.0/0"], "Allow any outbound traffic"],<br>["ingress", 443, 443, "tcp", null, ["0.0.0.0/0"], "HTTPS from Internal"],<br>["ingress", 3306, 3306, "tcp", null, ["0.0.0.0/0"], "MySQL from Internal"] |
| name_tag_prefix    | Name タグの接頭辞                    | Option  | ""                                                                                                                                                                                                                                    |

# Outputs

モジュールの出力は以下のとおりです。

| Name            | Description                               |
| :-------------- | :---------------------------------------- |
| vpc_id          | VPC ID                                    |
| public_subnets  | パブリックサブネット(リスト)              |
| private_subnets | プライベートサブネット(リスト)            |
| public_RT_id    | パブリックサブネットのルートテーブル ID   |
| private_RT_id   | プライベートサブネットのルートテーブル ID |
| default_sg_id   | デフォルトセキュリティグループ ID         |
| frontend_sg_id  | フロントエンド用セキュリティグループ ID   |
| backend_sg_id   | バックエンド用セキュリティグループ ID     |
