# Databricks workspace metastore assignment
resource "databricks_metastore_assignment" "this" {
  provider = databricks.mws
  metastore_id = local.vars.dbricks.conn.metastore_id
  workspace_id =  databricks_mws_workspaces.this.workspace_id
}