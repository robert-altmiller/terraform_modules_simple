data "local_file" "yamlvars" {
  filename = "./render_env_yml/env.yml"
}

locals {
  vars = yamldecode(data.local_file.yamlvars.content)
}

locals {
  cluster_policies_definitions = {
    "cluster_policies" = {
      "cluster_policy_dev" = {
        resource_name = "cluster_policy_dev-${local.vars.dbricks.general.prefix}",
        nodetype_id = ["i3.2xlarge"],
        spark_version = "auto:latest-ml",
        runtime_engine = "STANDARD",
        num_workers = 4,
        min_workers = 1,
        max_workers = 4,
        cluster_type = "all-purpose",
        cluster_profile = "singleNode",
        auto_termination_mins = 120,
        groups = {
          "dev-contributors" = "CAN_USE",
          "dev-readers" = "CAN_USE"
        }
      },
      "cluster_policy_test" = {
        resource_name = "cluster_policy_test-${local.vars.dbricks.general.prefix}",
        nodetype_id = ["i3.2xlarge"],
        spark_version = "auto:latest-ml",
        runtime_engine = "STANDARD",
        num_workers = 4,
        min_workers = 1,
        max_workers = 4,
        cluster_type = "all-purpose",
        cluster_profile = "singleNode",
        auto_termination_mins = 120,
        groups = {
          "dev-contributors" = "CAN_USE",
          "dev-readers" = "CAN_USE"
        }
      }
    }
  }
}
