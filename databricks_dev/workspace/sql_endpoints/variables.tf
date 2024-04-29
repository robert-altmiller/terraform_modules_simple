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