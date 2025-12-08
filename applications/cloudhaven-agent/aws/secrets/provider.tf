terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "cloudhaven-tf-bucket-state"
    use_lockfile = true
    key          = "applications/cloudhaven-agent/aws/secrets"
    region       = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
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
  config = yamldecode(file("${path.module}/../../config.yaml"))
  default_tags = {
    application = local.config.application
    managedBy = local.config.managedBy
    project   = local.config.project
    region    = local.config.region
  }
}