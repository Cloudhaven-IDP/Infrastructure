terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "cloudhaven-tf-bucket-state"
    use_lockfile = true
    key          = "platform/pi-cluster/aws/iam/oidc-providers"
    region       = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
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
    network   = local.config.network
    managedBy = local.config.managedBy
    project   = local.config.project
    region    = local.config.region
    cluster   = local.config.cluster
  }
}