data "local_file" "yamlvars" {
  filename = "./render_env_yml/env.yml"
}

locals {
  vars = yamldecode(data.local_file.yamlvars.content)
}