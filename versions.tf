terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }

  backend "s3" {
    bucket  = "trade-tariff-terraform-state"
    key     = "common/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

provider "aws" {}

/* Additional provider configuration for us-east-1 region */
provider "aws" {
  alias  = "east"
  region = "us-east-1"
}