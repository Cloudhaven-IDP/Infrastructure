terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket  = "cloudhaven-tf-bucket-state"
    key     = "platform/nebulosa/aws/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

locals {
  config = yamldecode(file("${path.module}/../config.yaml"))
}

provider "aws" {
  region = local.config.region
}
