# Databricks sql endpoint permissions
resource "databricks_permissions" "sql_endpoint" {
  depends_on = [databricks_sql_endpoint.this]
  provider        = databricks.workspace
  sql_endpoint_id = databricks_sql_endpoint.cdsi_warehouse.id

  access_control {
    group_name       = local.vars.dbricks.conn.client_id
    permission_level = "ALL_PRIVILEGES"
  }

  access_control {
    group_name       = local.vars.dbricks.ws.mws_admin_group
    permission_level = "ALL_PRIVILEGES"
  }

  dynamic "access_control" {
    for_each = try(each.value["groups"], {})
    content {
      group_name  = grant.key
      permission_level = try(grant.value, [""])
    }
  }
}