data "local_file" "yamlvars" {
  filename = "./render_env_yml/env.yml"
}

locals {
  vars = yamldecode(data.local_file.yamlvars.content)
}

variable "cluster_availability" {
  type        = string
  description = "cluster availability"
  default = "SPOT_WITH_FALLBACK"
}

locals {
  sql_endpoints_definitions = {
    "sql_endpoints" = {
      "sql_ep_dev" = {
        resource_name = "sql_ep_dev-${local.vars.dbricks.general.prefix}",
        cluster_size = "X-Large",
        enable_serverless_compute = true,
        auto_stop_mins = 120,
        groups = {
          "dev-contributors" = ["CAN_USE"],
          "dev-readers" = ["CAN_USE"]
        }
      },
      "sql_ep_test" = {
        resource_name = "sql_ep_test-${local.vars.dbricks.general.prefix}",
        cluster_size = "X-Large",
        enable_serverless_compute = true,
        auto_stop_mins = 120,
        groups = {
          "dev-contributors" = ["CAN_USE"],
          "dev-readers" = ["CAN_USE"]
        }
      }
    }
  }
}
