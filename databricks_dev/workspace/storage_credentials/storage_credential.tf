# Databricks storage credential
resource "databricks_storage_credential" "this" {
  provider      = databricks.workspace
  for_each      = local.storage_credentials_definitions["storage_credentials"]
  name          = try(each.value["resource_name"], "")
  aws_iam_role {
    role_arn = var.sc_iam_role_arn # <-- PAY ATTENTION TO HOW THIS IS DONE
  }
  owner = local.vars.dbricks.conn.client_id
  force_destroy = true
}