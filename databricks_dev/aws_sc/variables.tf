data "local_file" "yamlvars" {
  filename = "./render_env_yml/env.yml"
}

locals {
  vars = yamldecode(data.local_file.yamlvars.content)
}


locals {
  assume_role_policy_json = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "AWS" = [
            "arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"
          ]
        },
        "Action" = "sts:AssumeRole",
        "Condition" = {
          "StringEquals" = {
            "sts:ExternalId" = "${local.vars.dbricks.conn.account_id}"
          }
        }
      }
    ]
  })
}

locals {
  assume_role_policy_updated_json = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "AWS" = [
            "arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL",
            "arn:aws:iam::${local.vars.aws.conn.account_id}:role/${local.vars.dbricks.sc.sc_iam_role_external_assume}"
          ]
        },
        "Action" = "sts:AssumeRole",
        "Condition" = {
          "StringEquals" = {
            "sts:ExternalId" = "${local.vars.dbricks.conn.account_id}"
          }
        }
      }
    ]
  })
}