data "local_file" "yamlvars" {
  filename = "./render_env_yml/env.yml"
}

locals {
  vars = yamldecode(data.local_file.yamlvars.content)
}


locals {
  catalogs_definitions = {
    "catalogs" = {
      "catalog_dev" = {
        resource_name = "catalog_dev_${local.vars.dbricks.general.prefix}",
        storage_root  = "s3://${local.vars.dbricks.general.prefix}-dev-bucket/",
        groups = {
          "dev-contributors" = ["USE_CATALOG"],
          "dev-readers" = ["BROWSE", "CREATE_MATERIALIZED_VIEW", "CREATE_MODEL", "CREATE_SCHEMA",
                           "CREATE_TABLE", "SELECT", "USE_CATALOG", "USE_SCHEMA"
          ]
        }
      },
      "catalog_test" = {
        resource_name = "catalog_test_${local.vars.dbricks.general.prefix}",
        storage_root  = "s3://${local.vars.dbricks.general.prefix}-stage-bucket/",
        groups = {
          "dev-contributors" = ["USE_CATALOG"],
          "dev-readers" = ["BROWSE", "CREATE_MATERIALIZED_VIEW", "CREATE_MODEL", "CREATE_SCHEMA",
                           "CREATE_TABLE", "SELECT", "USE_CATALOG", "USE_SCHEMA"
          ]
        }
      }
    }
  }
}
