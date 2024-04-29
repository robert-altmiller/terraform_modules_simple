# Get an existing mws account group name (admins)
data "databricks_group" "existing_group_admins_account" {
  provider = databricks.mws
  display_name = local.vars.dbricks.ws.mws_admin_group
}

# Get an existing mws account group name (contributors)
data "databricks_group" "existing_group_contributors_account" {
  provider = databricks.mws
  display_name = local.vars.dbricks.ws.mws_contributor_group
}

# Get an existing mws account group name (readers)
data "databricks_group" "existing_group_readers_account" {
  provider = databricks.mws
  display_name = local.vars.dbricks.ws.mws_reader_group
}

# Add account level mws admin group as a workspace admin (must wait 60 - 120 seconds)
resource "databricks_mws_permission_assignment" "add_existing_group_admins" {
  depends_on = [databricks_mws_workspaces.this, time_sleep.wait_2_minutes]
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.this.workspace_id
  principal_id = data.databricks_group.existing_group_admins_account.id
  permissions  = ["ADMIN"]
}

# Add account level mws contributors and readers group as a workspace user (must wait 60 - 120 seconds)
resource "databricks_mws_permission_assignment" "add_existing_group_contributors_readers" {
  depends_on = [databricks_mws_workspaces.this, time_sleep.wait_2_minutes]
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.this.workspace_id

  for_each = {
    "group_contributors" = data.databricks_group.existing_group_contributors_account.id,
    "group_readers" = data.databricks_group.existing_group_readers_account.id
  }

  principal_id = each.value
  permissions  = ["USER"]
}


# Add all entitlements to the account level mws admin group in the workspace
# this can only be done once the account level group is added to the workspace
# must wait 60 - 120 seconds
resource "databricks_entitlements" "existing_group_admins_entitlements" {
  depends_on = [databricks_mws_permission_assignment.add_existing_group_admins, time_sleep.wait_2_minutes]
  provider                   = databricks.workspace
  group_id                   = data.databricks_group.existing_group_admins_account.id
  workspace_access           = true
  databricks_sql_access      = true
  allow_cluster_create       = true
  allow_instance_pool_create = true
}

# Wait for 2 minutes
resource "time_sleep" "wait_2_minutes" {
  create_duration = "120s"
}