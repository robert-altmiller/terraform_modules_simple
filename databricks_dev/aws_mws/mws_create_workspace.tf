# Databrick managed workspace credentials (must wait 10 seconds)
resource "databricks_mws_credentials" "this" {
  depends_on = [aws_iam_role.cross_account_role, time_sleep.wait_10_seconds]
  provider         = databricks.mws
  role_arn         = aws_iam_role.cross_account_role.arn
  credentials_name = local.vars.dbricks.ws.mws_credentials_name
}

# Databricks managed workspace storage configurations
resource "databricks_mws_storage_configurations" "this" {
  provider                   = databricks.mws
  account_id                 = local.vars.dbricks.conn.account_id
  bucket_name                = aws_s3_bucket.root_storage_bucket.bucket
  storage_configuration_name = local.vars.dbricks.ws.mws_storage_config_name
}

# Databricks managed workspace networks
resource "databricks_mws_networks" "this" {
  provider           = databricks.mws
  account_id         = local.vars.dbricks.conn.account_id
  network_name       = local.vars.dbricks.ws.mws_network_name
  security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids         = module.vpc.private_subnets
  vpc_id             = module.vpc.vpc_id
}

# Create a databricks workspace
resource "databricks_mws_workspaces" "this" {
  provider       = databricks.mws
  account_id     = local.vars.dbricks.conn.account_id
  aws_region     = local.vars.aws.conn.region
  workspace_name = local.vars.dbricks.ws.name
  deployment_name = local.vars.dbricks.ws.deployment_name

  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id               = databricks_mws_networks.this.network_id

  token {
    comment = "Managed By Terraform (TF)"
  }
}

# Define outputs to share with the root module for Workspace level provider configuration
output "workspace_url" {
  value = databricks_mws_workspaces.this.workspace_url
}

# Define outputs to share with the root module for Workspace level provider configuration
output "workspace_token" {
  value = databricks_mws_workspaces.this.token[0].token_value
}

# Wait for 10 seconds
resource "time_sleep" "wait_10_seconds" {
  create_duration = "10s"
}