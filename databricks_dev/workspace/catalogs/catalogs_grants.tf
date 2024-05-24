# Databricks catalog grants
resource "databricks_grants" "catalog_grants" {
  depends_on = [databricks_catalog.this]
  for_each     = local.catalogs_definitions["catalogs"]
  #for_each   = jsondecode(file("${path.module}/catalogs.json"))["catalogs"]
  provider   = databricks.workspace
  catalog    = databricks_catalog.this[each.key].id

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