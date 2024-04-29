terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws" 
    }
  }
}

data "aws_caller_identity" "current" {}