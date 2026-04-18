terraform {
  required_version = ">= 1.5"

  required_providers {
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.17"
    }
  }

  backend "s3" {
    bucket  = "cloudhaven-tf-bucket-state"
    key     = "platform/nebulosa/tailscale/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

locals {
  config = yamldecode(file("${path.module}/../config.yaml"))
  tailscale_api_key = data.aws_ssm_parameter.tailscale_api_key.value
}


provider "tailscale" {
  tailnet = "nebulosa-humboldt.ts.net"
  api_key = local.tailscale_api_key
}
