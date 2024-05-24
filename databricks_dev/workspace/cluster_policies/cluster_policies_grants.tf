# Databricks cluster policy grants
resource "databricks_permissions" "cluster_policy_permissions" {
  depends_on = [databricks_cluster_policy.this]
  for_each   = local.cluster_policies_definitions["cluster_policies"]
  provider   = databricks.workspace
  cluster_policy_id = databricks_cluster_policy.this[each.key].id

  access_control {
    service_principal_name = local.vars.dbricks.conn.client_id
    permission_level       = "CAN_USE"
  }

  access_control {
    group_name       = local.vars.dbricks.ws.mws_admin_group
    permission_level = "CAN_USE"
  }

  dynamic "access_control" {
    for_each = try(each.value["groups"], {})
    content {
      group_name  = access_control.key
      permission_level = try(access_control.value, "")
    }
  }
}