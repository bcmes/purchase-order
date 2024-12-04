terraform {
  required_providers {
    aws = "~> 5.0"
    local = ">=2.1.0"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}