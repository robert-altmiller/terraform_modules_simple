#!/bin/bash

# Function to handle errors
handle_error() {
  echo "An error occurred during script execution. Exiting..."
  exit 1
}

# Trap errors and call the handle_error function
trap handle_error ERR

# Run Terraform commands
terraform init -upgrade # Initialize and upgrade providers
terraform plan -lock=false # Create a plan for Terraform deployment
terraform apply -lock=false -auto-approve # Apply the Terraform plan

# Step 1: Create a 'databricks_account' folder.

# Step 2: Create a backup of the current 'databricks_dev' folder 'terraform.tfstate' and rename it as 'terraform.tfstate.bkup'.

# Step 2: Copy the current 'databricks_dev' folder 'terraform.tfstate' file into the 'databricks_account' folder.

# Step 3: Copy the 'aws_mws' and 'aws_sc' folders in the 'databricks_dev' folder into the 'databricks_account' folder.

# Step 4: Copy the root level 'modules.tf', 'variables.tf', and 'providers.tf' into the 'databricks_account' folder.

# Step 5: Modify the 'databricks_dev' folder terraform.tfstate to remove the 'aws_mws' and 'aws_sc' modules from it by running the following commands:
  # terraform state rm 'module.aws_mws' # Remove a Terraform module
  # terraform state rm 'module.aws_sc' # Remove a Terraform module

# step 6: Update the 'databricks_folder' modules.tf and remove all the modules except for 'aws_mws' and 'aws_sc' modules.

# Step 7: Modify the 'databricks_account' folder terraform.tfstate to remove the modules from it by running the following commands.
  # terraform init
  # terraform state rm 'module.ws_storage_credentials_module' # Remove a Terraform module
  # terraform state rm 'module.ws_external_locations_module' # Remove a Terraform module
  # terraform state rm 'module.ws_catalogs_module' # Remove a Terraform module
  # terraform state rm 'module.ws_schemas_module' # Remove a Terraform module
  # terraform state rm 'module.ws_cluster_policies_module' # Remove a Terraform module

# step 8: Create an 'outputs.tf' in the root level of the 'databricks_account' folder and add the following.
  # Used with Storage Credentials Terraform module
  # output "aws_iam_role_arn_for_databricks_storage_creds" {
  # value = module.aws_sc.aws_iam_role_arn_for_databricks_storage_creds
  # }

# step 9: Add the following terraform_remote_source to the 'databricks_dev' modules.tf file:
  # Terraform remote source to read remote state file in cloud or local
  # data "terraform_remote_state" "aws_infra" {
  #   backend = "local"
  #   config = {
  #     path = "../databricks_account/terraform.tfstate"
  #   }
  # }

# step 10: Comment out the 'aws_mws' and 'aws_sc' modules in the modules.tf in the 'databricks_dev' folder

# step 11: Update the 'ws_storage_credentials_module' in the 'modules.tf' in the 'databricks_dev' folder with the following:
  # sc_iam_role_arn = data.terraform_remote_state.aws_infra.outputs.aws_iam_role_arn_for_databricks_storage_creds

# step 12: Run 'terraform init' and 'terraform refresh' in the 'databricks_account' folder to sync the 'databricks_account' folder 'terraform.tfstate' 
# with the deployed infrastructure.  Run 'terraform plan' against the 'databricks_account' folder to ensure no new resources are trying get deployed or deleted.

  host          = local.vars.dbricks.conn.instance_url

# step 14: Run 'terraform refresh' in the 'databricks_dev' folder to sync the 'databricks_dev' folder 'terraform.tfstate' 
# with the deployed infrastructure.  Run 'terraform plan' against the 'databricks_dev' folder to ensure no new resources are trying get deployed or deleted.