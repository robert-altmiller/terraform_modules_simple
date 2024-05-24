# Databricks schema grants
resource "databricks_grants" "schema_grants" {
  depends_on = [databricks_schema.this]
  for_each   = local.schemas_definitions["schemas"]
  provider   = databricks.workspace
  schema    = try("${each.value.catalog_name}.${each.value.resource_name}", "")

  grant {
    principal  = local.vars.dbricks.conn.client_id
    privileges = ["ALL_PRIVILEGES"]
  }

  grant {
    principal  = local.vars.dbricks.ws.mws_admin_group
    privileges = ["ALL_PRIVILEGES"]
  }

  dynamic "grant" {
    for_each = try(each.value["groups"], {})
    content {
      principal  = grant.key
      privileges = try(grant.value, [""])
    }
  }
}
