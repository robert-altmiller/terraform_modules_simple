resource "databricks_grants" "external_location_grants" {
  depends_on = [databricks_external_location.this]
  for_each   = local.external_locations_definitions["external_locations"]
  provider   = databricks.workspace
  external_location = databricks_external_location.this[each.key].id

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