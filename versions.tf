terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws",
      version = "~> 3.17.0"
    }
  }
}


locals {
  region = "us-east-2"
}

provider "aws" {
  region = local.region
}