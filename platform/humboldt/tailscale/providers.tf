terraform {
  required_version = ">= 1.5"

  required_providers {
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.17"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "cloudhaven-tf-bucket-state"
    key     = "platform/humboldt/tailscale/terraform.tfstate"
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

# API token via TAILSCALE_API_KEY env var
provider "tailscale" {
  tailnet = "nebulosa-humboldt.ts.net"
}

provider "aws" {
  region = local.config.region

  default_tags {
    tags = local.default_tags
  }
}
