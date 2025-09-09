terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.100.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "= 2.7.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.7.2"
    }
  }

  # Backend config is provided via CLI flags in GitHub Actions
  backend "s3" {
    # leave empty, values supplied via -backend-config
  }
}

provider "aws" {
  region = var.aws_region
}
