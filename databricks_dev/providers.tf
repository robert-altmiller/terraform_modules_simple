# Terraform required providers
terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "~> 1.39.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }
  }
}

# AWS provider
provider "aws" {
  region     = local.vars.aws.conn.region
  access_key = local.vars.aws.conn.access_key
  secret_key = local.vars.aws.conn.access_key_secret
}

# Initialize provider in "MWS" mode to provision new workspace
provider "databricks" {
  alias         = "mws"
  host          = local.vars.dbricks.conn.account_url
  account_id    = local.vars.dbricks.conn.account_id
  client_id     = local.vars.dbricks.conn.client_id
  client_secret = local.vars.dbricks.conn.client_secret
}


# Initialize provider in "WORKSPACE" mode to provision new workspace
provider "databricks" {
  alias         = "workspace"
  host          = module.aws_mws.workspace_url
  token         = module.aws_mws.workspace_token
}

# Configure the TIME provider
provider "time" {}