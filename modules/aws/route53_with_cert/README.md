# Description

このモジュールでは、AWS の Route53 でホストゾーンと ACM でパブリック証明書を作成します。証明書は作成したホストゾーンで DNS 検証します。

# Usage

モジュールの使用例です。

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

# Requirements

前提とする Terraform,プロバイダーは以下のとおりです。

| Name      | Version   |
| :-------- | :-------- |
| terraform | >= 1.1.4  |
| aws       | >= 3.73.0 |

# Resources

作成されるリソースは以下のとおりです。

| Name                               | Type     |
| :--------------------------------- | :------- |
| aws_route53_zone.hostedzone        | resource |
| aws_acm_certificate.cert           | resource |
| aws_route53_record.cert_validation | resource |

# Inputs

指定できる引数は以下のとおりです。

| Name             | Description              | Require |
| :--------------- | :----------------------- | :------ |
| domain_name      | ホストゾーンのドメイン名 | Require |
| comment          | ホストゾーンの説明       | Option  |
| hostedzone_tags  | ホストゾーンのタグ       | Option  |
| cert_domain_name | 完全修飾ドメイン名       | Require |
| cert_tags        | 証明書のタグ             | Option  |

# Outputs

モジュールの出力は以下のとおりです。

| Name     | Description             |
| :------- | :---------------------- |
| zone_id  | ホストゾーンのゾーン ID |
| cert_arn | 証明書の ARN            |
