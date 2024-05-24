data "local_file" "yamlvars" {
  filename = "./render_env_yml/env.yml"
}

locals {
  vars = yamldecode(data.local_file.yamlvars.content)
}

locals {
  external_locations_definitions = {
    "external_locations" = {
      "el-dev" = {
        resource_name = "el-dev-${local.vars.dbricks.general.prefix}",
        storage_root  = "s3://${local.vars.dbricks.general.prefix}-dev-bucket/",
        storage_credential_name = "sc-dev-${local.vars.dbricks.general.prefix}",
        groups = {
          "dev-contributors" = ["CREATE_EXTERNAL_TABLE", "CREATE_EXTERNAL_VOLUME", "CREATE_MANAGED_STORAGE", "READ_FILES", "WRITE_FILES"],
          "dev-readers" = ["READ_FILES"]
        }
      },
      "el-test" = {
        resource_name = "el-test-${local.vars.dbricks.general.prefix}",
        storage_root  = "s3://${local.vars.dbricks.general.prefix}-stage-bucket/",
        storage_credential_name = "sc-test-${local.vars.dbricks.general.prefix}",
        groups = {
          "dev-contributors" = ["CREATE_EXTERNAL_TABLE", "CREATE_EXTERNAL_VOLUME", "CREATE_MANAGED_STORAGE", "READ_FILES", "WRITE_FILES"],
          "dev-readers" = ["READ_FILES"]
        }
      }
    }
  }
}
