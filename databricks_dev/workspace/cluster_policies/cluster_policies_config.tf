# Databricks cluster policy config settings
locals {
  decoded_cluster_policy_config = local.cluster_policies_definitions["cluster_policies"]
  cluster_policy_config_settings = { 
    for key, config in local.decoded_cluster_policy_config : key => { 
      node_type_id = {
        type         = "allowlist",
        values       = try(config.nodetype_id, "")
        defaultValue = "i3.xlarge"
      },
      spark_version = {
        type         = "unlimited",
        defaultValue = try(config.spark_version, "")
      },
      runtime_engine = {
        type: "fixed",
        value: try(config.runtime_engine, "")
        hidden: true
      },
      num_workers = {
        type   = "fixed",
        value  = try(tonumber(config.num_workers), "")
        hidden = true
      },
      driver_instance_pool_id = {
        type   = "forbidden",
        hidden = true
      },
      cluster_type = {
        type  = "fixed",
        value = try(config.cluster_type, "")
      },
      instance_pool_id = {
        type   = "forbidden",
        hidden = true
      },
      "spark_conf.spark.databricks.cluster.profile" = {
        type = "fixed",
        value = try(config.cluster_profile, ""),
        hidden = true
      },
      autotermination_minutes = {
        type       = "unlimited",
        defaultValue = try(tonumber(config.auto_termination_mins), "30"),
        isOptional = true
      }
    }
  }
}



# {
#   "spark_conf.spark.databricks.cluster.profile": {
#     "type": "forbidden",
#     "hidden": true
#   },
#   "spark_version": {
#     "type": "unlimited",
#     "defaultValue": "auto:latest-lts"
#   },
#   "enable_elastic_disk": {
#     "type": "fixed",
#     "value": true,
#     "hidden": true
#   },
#   "node_type_id": {
#     "type": "unlimited",
#     "defaultValue": "i3.xlarge",
#     "isOptional": true
#   },
#   "num_workers": {
#     "type": "unlimited",
#     "defaultValue": 4,
#     "isOptional": true
#   },
#   "aws_attributes.availability": {
#     "type": "fixed",
#     "value": "SPOT_WITH_FALLBACK",
#     "hidden": true
#   },
#   "aws_attributes.first_on_demand": {
#     "type": "range",
#     "minValue": 1,
#     "defaultValue": 1
#   },
#   "aws_attributes.zone_id": {
#     "type": "unlimited",
#     "defaultValue": "auto",
#     "hidden": true
#   },
#   "aws_attributes.spot_bid_price_percent": {
#     "type": "fixed",
#     "value": 100,
#     "hidden": true
#   },
#   "instance_pool_id": {
#     "type": "forbidden",
#     "hidden": true
#   },
#   "driver_instance_pool_id": {
#     "type": "forbidden",
#     "hidden": true
#   },
#   "cluster_type": {
#     "type": "fixed",
#     "value": "job"
#   }
# }