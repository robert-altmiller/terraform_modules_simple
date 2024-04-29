# Databricks catalog
resource "databricks_catalog" "this" {
  provider     = databricks.workspace
  for_each     = jsondecode(file("${path.module}/catalogs.json"))["catalogs"]
  metastore_id = local.vars.dbricks.conn.metastore_id
  name         = try(each.value["resource_name"], "")
  storage_root = try(each.value["storage_root"], "")
  owner        = local.vars.dbricks.conn.client_id
  force_destroy = true
}