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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket  = "cloudhaven-tf-bucket-state"
    key     = "platform/humboldt/argocd/terraform.tfstate"
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

provider "argocd" {
  server_addr = "argocd.cloudhaven.work:80" #techdebt pending clusterissuer deployment
  plain_text  = true
  grpc_web    = true
  auth_token  = var.argocd_token
}

provider "kubernetes" {
  alias                  = "nebulosa"
  host                   = local.kube["host"]
  client_certificate     = base64decode(local.kube["client-certificate"])
  client_key             = base64decode(local.kube["client-key"])
  cluster_ca_certificate = base64decode(local.kube["cluster-ca-certificate"])
}
