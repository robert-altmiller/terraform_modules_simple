# Databricks schema
resource "databricks_schema" "this" {
  provider     = databricks.workspace
  for_each     = jsondecode(file("${path.module}/schemas.json"))["schemas"]
  catalog_name = try(each.value["catalog_name"], "")
  name         = try(each.value["resource_name"], "")
  storage_root = try(each.value["storage_root"], "")
  owner        = local.vars.dbricks.conn.client_id
  force_destroy = true
}