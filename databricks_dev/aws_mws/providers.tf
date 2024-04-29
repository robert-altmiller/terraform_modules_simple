terraform {
  required_providers {
    databricks = {
      source                = "databricks/databricks"
      configuration_aliases = [databricks.workspace, databricks.mws]
    }
    aws = {
      source                = "hashicorp/aws" 
    }
  }
}

# data "aws_caller_identity" "current" {}