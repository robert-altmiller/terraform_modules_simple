resource "databricks_external_location" "this" {
  provider        = databricks.workspace
  for_each        = local.external_locations_definitions["external_locations"]
  name            = try(each.value["resource_name"], "")
  url             = try(each.value["storage_root"], "")
  credential_name = try(each.value["storage_credential_name"], "")
  comment         = "Managed By Terraform"
  force_destroy   = true
  force_update    = true
}