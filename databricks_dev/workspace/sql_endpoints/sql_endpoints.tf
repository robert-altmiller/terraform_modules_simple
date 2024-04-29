# Databricks sql endpoint
resource "databricks_sql_endpoint" "this" {
  provider                  = databricks.workspace
  name                      = try(each.value["resource_name"], "")
  cluster_size              = try(each.value["cluster_size"], "")
  enable_serverless_compute = try(each.value["enable_serverless_compute"], "")
  auto_stop_mins            = try(each.value["auto_stop_mins"], "")
  tags {
    custom_tags {
      key   = "ManagedBy"
      value = "Managed by Terraform (TF)"
    }
  }
  owner = local.vars.dbricks.ws.client_id
}