# Databricks cluster permissions
resource "databricks_permissions" "cluster_permissions" {
  depends_on = [databricks_cluster.this]
  for_each   = jsondecode(file("${path.module}/clusters.json"))["clusters"]
  provider   = databricks.workspace
  cluster_id = databricks_cluster.this[each.key].id

  access_control {
    group_name       = local.vars.dbricks.conn.client_id
    permission_level = "CAN_MANAGE"
  }

  access_control {
    group_name       = local.vars.dbricks.ws.mws_admin_group
    permission_level = "CAN_MANAGE"
  }

  # Iterate over groups to assign permissions
  dynamic "access_control" {
    for_each = each.value["groups"]  # Iterates over groups in the JSON file
    content {
      group_name = access_control.key  # The group name
      permission_level = try(access_control.value, "")  # Assign each permission
    }
  }
}