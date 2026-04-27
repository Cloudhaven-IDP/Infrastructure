terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~> 7.0"
    }
  }

  backend "s3" {
    bucket  = "cloudhaven-tf-bucket-state"
    key     = "platform/nebulosa/argocd/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

locals {
  config = yamldecode(file("${path.module}/../config.yaml"))
}

data "aws_ssm_parameter" "argocd_token" {
  name            = "/restricted/argocd/admin/token"
  with_decryption = true
}

provider "aws" {
  region = local.config.region
}

provider "argocd" {
  server_addr = "argocd.internal.cloudhaven.work:80"
  plain_text  = true
  grpc_web    = true
  auth_token  = data.aws_ssm_parameter.argocd_token.value
}