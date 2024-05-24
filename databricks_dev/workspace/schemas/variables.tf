data "local_file" "yamlvars" {
  filename = "./render_env_yml/env.yml"
}

locals {
  vars = yamldecode(data.local_file.yamlvars.content)
}

locals {
  schemas_definitions = {
    "schemas" = {
      "schema_dev" = {
        catalog_name  = "catalog_dev_${local.vars.dbricks.general.prefix}",
        resource_name = "schema_dev-${local.vars.dbricks.general.prefix}",
        storage_root  = "s3://${local.vars.dbricks.general.prefix}-dev-bucket/",
        groups = {
          "dev-contributors" = ["USE_SCHEMA", "SELECT"],
          "dev-readers" = ["USE_SCHEMA", "SELECT"]
        }
      },
      "schema_test" = {
        catalog_name  = "catalog_test_${local.vars.dbricks.general.prefix}",
        resource_name = "schema_test_${local.vars.dbricks.general.prefix}",
        storage_root  = "s3://${local.vars.dbricks.general.prefix}-stage-bucket/",
        groups = {
          "dev-contributors" = [
            "USE_SCHEMA", "APPLY_TAG", "EXECUTE", "MODIFY", "READ_VOLUME", "REFRESH", "SELECT", 
            "WRITE_VOLUME", "CREATE_FUNCTION", "CREATE_MATERIALIZED_VIEW", "CREATE_MODEL", 
            "CREATE_TABLE", "CREATE_VOLUME"
          ],
          "dev-readers" = [
            "USE_SCHEMA", "EXECUTE", "MODIFY", "READ_VOLUME", "REFRESH", "SELECT"
          ]
        }
      }
    }
  }
}
