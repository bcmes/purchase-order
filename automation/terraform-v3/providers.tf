terraform {
  required_providers {
    aws = "~> 5.0"
    local = ">=2.1.0"
  }
  backend "s3" { #Serve para enviar meu .tfstate para aws s3, para controle centralizado, apartir do s3. Obs.: Esse nome s3 não é aleatório.
    bucket = "my-bucket-tfstate" #o bucket deve existir previamente na aws
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}