terraform {
  required_version = ">= 1.6"

  required_providers {
    aws     = { source = "hashicorp/aws", version = "~> 5.0" }
    archive = { source = "hashicorp/archive", version = "~> 2.4" }
    random  = { source = "hashicorp/random", version = "~> 3.6" }
  }

  # Backend config is provided via backend-dev.hcl at init
  backend "s3" {
    bucket         = "" # overridden at init
    key            = "" # overridden at init
    region         = "" # overridden at init
    dynamodb_table = "" # overridden at init
  }
}

provider "aws" {
  region = var.aws_region
}
