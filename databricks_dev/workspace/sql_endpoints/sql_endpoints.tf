# Databricks sql endpoint
# Databricks SQL endpoint
resource "databricks_sql_endpoint" "this" {
  provider                  = databricks.workspace
  for_each                  = local.sql_endpoints_definitions["sql_endpoints"]
  name                      = each.value.resource_name
  cluster_size              = each.value.cluster_size
  enable_serverless_compute = each.value.enable_serverless_compute
  auto_stop_mins            = each.value.auto_stop_mins
  tags {
    custom_tags {
      key   = "ManagedBy"
      value = "Managed by Terraform (TF)"
    }
  }
  owner = local.vars.dbricks.ws.client_id
}
