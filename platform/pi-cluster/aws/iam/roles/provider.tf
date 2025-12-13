terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "cloudhaven-tf-bucket-state"
    use_lockfile = true
    key          = "platform/pi-cluster/aws/iam/roles"
    region       = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
  config = yamldecode(file("${path.module}/../../../config.yaml"))
  default_tags = {
    managedBy = local.config.managedBy
    account   = local.config.account
    region    = local.config.region
    cluster   = local.config.cluster
  }
}