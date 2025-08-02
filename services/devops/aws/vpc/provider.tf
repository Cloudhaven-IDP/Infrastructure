terraform {

  backend "s3" {
    encrypt        = true
    bucket         = "cloudhaven-tf-state"
    dynamodb_table = "devops-tf-state-lock"
    key            = "services/devops/aws/vpc"
    region         = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  required_version = ">= 1.5"
}

provider "aws" {
  region = local.config.Region

  default_tags {
    tags = local.default_tags
  }
}

locals {
  config    = yamldecode(file("${path.module}/../config.yaml"))

  default_tags = {
    region    = local.config.Region
    Service   = local.config.Service
    Project   = local.config.Project
    ManagedBy = local.config.ManagedBy
  }
}
