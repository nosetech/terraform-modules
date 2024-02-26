# Description

このモジュールでは、AWS の ECR でプライベートリポジトリを作成します。

タグのイミュータビリティは無効、スキャン頻度は「プッシュ時にスキャン」、暗号化タイプは AES-256 とします。

# Usage

モジュールの使用例です。

    module "api_ecr" {
      source = "git::https://github.com/nosetech/terraform-modules.git//modules/aws/ecr"

      name   = "api"
      tags   = {
        Name = "api"
      }
    }

# Requirements

前提とする Terraform,プロバイダーは以下のとおりです。

| Name      | Version   |
| :-------- | :-------- |
| terraform | >= 1.5.0  |
| aws       | >= 5.13.0 |

# Resources

作成されるリソースは以下のとおりです。

| Name                    | Type     |
| :---------------------- | :------- |
| aws_ecr_repository.main | resource |

# Inputs

指定できる引数は以下のとおりです。

| Name | Description  | Require |
| :--- | :----------- | :------ |
| name | リポジトリ名 | Require |
| tags | タグ         | Option  |

# Outputs

モジュールの出力は以下のとおりです。

| Name           | Description      |
| :------------- | :--------------- |
| repository_url | リポジトリの URL |
