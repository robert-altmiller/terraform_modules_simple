# AWS and Databricks managed workspace infrastructure
module "aws_mws" {
  source = "./aws_mws"
  providers = {
    databricks.workspace = databricks.workspace
    databricks.mws = databricks.mws
    aws = aws
  }
}

# AWS infrastructure for Databricks storage credentials only
module "aws_sc" {
  depends_on = [module.aws_mws]
  source = "./aws_sc"
  providers = {
    aws = aws
  }
}

# Databricks storage credentials module
module "ws_storage_credentials_module" {
  depends_on = [module.aws_sc]
  source = "./workspace/storage_credentials"
  providers = {
    databricks.workspace = databricks.workspace
  }
  sc_iam_role_arn = module.aws_sc.aws_iam_role_arn_for_databricks_storage_creds
}

# Databricks external locations module
module "ws_external_locations_module" {
  depends_on = [module.ws_storage_credentials_module]
  source = "./workspace/external_locations"
  providers = {
    databricks.workspace = databricks.workspace
  }
}

# Databricks catalogs module
module "ws_catalogs_module" {
  depends_on = [module.ws_external_locations_module]
  source = "./workspace/catalogs"
  providers = {
    databricks.workspace = databricks.workspace
  }
}

# Databricks schemas module
module "ws_schemas_module" {
  depends_on = [module.ws_catalogs_module]
  source = "./workspace/schemas"
  providers = {
    databricks.workspace = databricks.workspace
  }
}

# Databricks cluster policies module
module "ws_cluster_policies_module" {
  # depends_on = [module.aws_mws]
  source = "./workspace/cluster_policies"
  providers = {
    databricks.workspace = databricks.workspace
  }
}

# # Databricks clusters module
# module "ws_clusters_module" {
#   depends_on = [module.aws_mws]
#   source = "./workspace/clusters"
#   providers = {
#     databricks.workspace = databricks.workspace
#   }
# }

# Databricks notebooks module
# module "ws_notebooks_module" {
#   depends_on = [module.aws_module]
#   source = "./workspace/notebooks"
#   providers = {
#     databricks.workspace = databricks.workspace
#   }
# }

# Databricks SQL endpoints module
# module "ws_sql_endpoints_module" {
#   depends_on = [module.aws_module]
#   source = "./workspace/sql_endpoints"
#   providers = {
#     databricks.workspace = databricks.workspace
#   }
# }