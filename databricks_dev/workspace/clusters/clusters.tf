# Databricks cluster worker node type
data "databricks_node_type" "gen_purpose_cluster_worker" {
  provider    = databricks.workspace
  local_disk  = true
  min_cores   = 2
  gb_per_core = 4
}

# Databricks cluster driver node type
data "databricks_node_type" "gen_purpose_cluster_driver" {
  provider    = databricks.workspace
  local_disk  = true
  min_cores   = 16
  gb_per_core = 4
}

# Databricks spark version
data "databricks_spark_version" "gen_purpose_cluster_spark_version" {
  provider          = databricks.workspace
  long_term_support = true
  gpu               = false
  ml                = false
}

# Databricks cluster
resource "databricks_cluster" "this" {
  provider                = databricks.workspace
  for_each                = jsondecode(file("${path.module}/clusters.json"))["clusters"]
  cluster_name            = try(each.value["resource_name"], "")
  spark_version           = data.databricks_spark_version.gen_purpose_cluster_spark_version.id
  node_type_id            = data.databricks_node_type.gen_purpose_cluster_worker.id
  driver_node_type_id     = data.databricks_node_type.gen_purpose_cluster_driver.id
  autotermination_minutes = var.cluster_auto_term_mins
  autoscale {
    min_workers = var.cluster_min_workers
    max_workers = var.cluster_max_workers
  }
  custom_tags = try(each.value["custom_tags"], "")
  aws_attributes {
    availability           = var.cluster_availability
    zone_id                = var.cluster_zone_id
    first_on_demand        = var.cluster_first_on_demand
    spot_bid_price_percent = var.cluster_spot_bid_price_percent
  }
  enable_elastic_disk = var.cluster_enable_elastic_disk
}