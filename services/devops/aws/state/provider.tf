terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = local.default_tags
  }
}

locals {
  config = yamldecode(file("${path.module}/../config.yaml"))
  default_tags = {
    Service   = local.config.Service
    Project   = local.config.Project
    ManagedBy = local.config.ManagedBy
  }
}