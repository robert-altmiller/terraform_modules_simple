# Databricks cluster policy
resource "databricks_cluster_policy" "this" {
  provider   = databricks.workspace
  for_each     = jsondecode(file("${path.module}/cluster_policies.json"))["cluster_policies"]
  name       = try(each.value["resource_name"], "")
  definition = jsonencode(local.cluster_policy_config_settings[each.key])
}