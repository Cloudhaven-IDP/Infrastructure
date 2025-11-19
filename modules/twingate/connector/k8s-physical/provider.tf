terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    twingate = {
      source  = "twingate/twingate"
      version = "~> 1.0"
    }
  }

  required_version = ">= 1.0"
}
