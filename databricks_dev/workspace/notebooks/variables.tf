data "local_file" "yamlvars" {
  filename = "./render_env_yml/env.yml"
}

locals {
  vars = yamldecode(data.local_file.yamlvars.content)
}

variable "workspace_directory" {
  type        = string
  description = "cluster availability"
  default = ""
}

locals {
  notebooks_definitions = {
    "notebooks" = {
      "notebooks_dev" = {
        notebooks_base_path = "/dev",
        notebooks_names_paths = {
          "idbdw_full_load_template.dbc" = "/dev_dbc_archive/idbdw_full_load_template.dbc"
        },
        groups = {
          "dev-contributors" = [""],  // Define specific permissions if needed
          "dev-readers" = [""]
        }
      },
      "notebooks_test" = {
        notebooks_base_path = "/test",
        notebooks_names_paths = {
          "idbdw_incremental_load_template.dbc" = "/test_dbc_archive/idbdw_incremental_load_template.dbc"
        },
        groups = {
          "dev-contributors" = [""],  // Define specific permissions if needed
          "dev-readers" = [""]
        }
      }
    }
  }
}
