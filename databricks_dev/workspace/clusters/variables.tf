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

variable "cluster_zone_id" {
  type        = string
  description = "cluster zone id"
  default = "auto"
}

variable "cluster_first_on_demand" {
  type        = number
  description = "cluster first on demand"
  default = 1
}

variable "cluster_spot_bid_price_percent" {
  type        = number
  description = "cluster spot bid price percent"
  default = 100
}

variable "cluster_auto_term_mins" {
  type        = number
  description = "cluster auto termination minutes"
  default = 120
}

variable "cluster_enable_elastic_disk" {
  type        = bool
  description = "cluster auto termination minutes"
  default = true
}

variable "cluster_min_workers" {
  type        = number
  description = "cluster auto termination minutes"
  default = 2
}

variable "cluster_max_workers" {
  type        = number
  description = "cluster auto termination minutes"
  default = 4
}

locals {
  clusters_definitions = {
    "clusters" = {
      "cluster_dev" = {
        resource_name = "cluster_dev_${local.vars.dbricks.general.prefix}",
        groups = {
          "dev-contributors" = "CAN_ATTACH_TO",
          "dev-readers" = "CAN_ATTACH_TO"
        },
        custom_tags = {
          "TenantName" = "AWS",
          "ClusterType" = "General Purpose",
          "Environment" = "Dev"
        }
      },
      "cluster_test" = {
        resource_name = "cluster_test_${local.vars.dbricks.general.prefix}",
        groups = {
          "dev-contributors" = "CAN_ATTACH_TO",
          "dev-readers" = "CAN_ATTACH_TO"
        },
        custom_tags = {
          "TenantName" = "AWS",
          "ClusterType" = "General Purpose",
          "Environment" = "Test"
        }
      }
    }
  }
}
