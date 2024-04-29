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