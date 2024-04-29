# Databricks storage credentials grants
resource "databricks_grants" "storage_credential_grants" {
  depends_on = [databricks_storage_credential.this]
  for_each   = jsondecode(file("${path.module}/storage_credentials.json"))["storage_credentials"]
  provider   = databricks.workspace
  storage_credential    = databricks_storage_credential.this[each.key].id

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