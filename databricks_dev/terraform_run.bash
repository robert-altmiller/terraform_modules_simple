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