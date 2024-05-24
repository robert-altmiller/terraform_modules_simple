data "local_file" "yamlvars" {
  filename = "./render_env_yml/env.yml"
}

locals {
  vars = yamldecode(data.local_file.yamlvars.content)
}

variable "sc_iam_role_arn" {
  type        = string
  description = "aws iam role arn for storage credentials (sc)"
}

locals {
  storage_credentials_definitions = {
    "storage_credentials" = {
      "sc-dev" = {
        resource_name = "sc-dev-${local.vars.dbricks.general.prefix}",
        groups = {
          "dev-contributors" = ["CREATE_EXTERNAL_LOCATION", "CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"],
          "dev-readers" = ["READ_FILES"]
        }
      },
      "sc-test" = {
        resource_name = "sc-test-${local.vars.dbricks.general.prefix}",
        groups = {
          "dev-contributors" = ["CREATE_EXTERNAL_LOCATION", "CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"],
          "dev-readers" = ["READ_FILES"]
        }
      }
    }
  }
}
