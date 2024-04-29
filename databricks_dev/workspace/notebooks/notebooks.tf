resource "databricks_directory" "this" {
  provider   = databricks.workspace
  for_each     = jsondecode(file("${path.module}/notebooks.json"))["notebooks"]
  path       = try(each.value["notebooks_base_path"], "")
}


resource "databricks_notebook" "this" {
  depends_on = [databricks_directory.this]
  provider   = databricks.workspace
  for_each     = jsondecode(file("${path.module}/notebooks.json"))["notebooks"]

  dynamic "source" {
    for_each = try(each.value["notebooks_names_paths"], {})
    content {
      source = "${path.module}/${try(source.value, "")}"

    }
  }

  dynamic "path" {
    for_each = try(each.value["notebooks_names_paths"], {})
    content {
      path = "${databricks_directory.mode_workspace_directory.path}/${try(source.key, "")}"

    }
  }
}



# resource "databricks_notebook" "idbdw_incremental_load_with_deletes_emr_aa_document" {
#   provider   = databricks.workspace
#   source     = "${path.module}/dbc_archive/idbdw_incremental_load_with_deletes_emr_aa_document.dbc"
#   path       = "${databricks_directory.mode_workspace_directory.path}/idbdw_incremental_load_with_deletes_emr_aa_document"
#   depends_on = [databricks_directory.mode_workspace_directory]
# }