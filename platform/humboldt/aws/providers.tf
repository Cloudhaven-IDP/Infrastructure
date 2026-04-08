terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "cloudhaven-tf-bucket-state"
    key     = "platform/humboldt/aws/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

locals {
  config = yamldecode(file("${path.module}/../config.yaml"))

  default_tags = {
    ManagedBy   = local.config.managedBy
    Account     = local.config.account
    Cluster     = local.config.cluster
    Environment = local.config.environment
  }
}

provider "aws" {
  region = local.config.region

  default_tags {
    tags = local.default_tags
  }
}
