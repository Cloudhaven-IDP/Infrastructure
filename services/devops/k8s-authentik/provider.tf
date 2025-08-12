terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "cloudhaven-tf-state"
    dynamodb_table = "devops-tf-state-lock"
    key            = "services/devops/authentik/authentik"
    region         = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }  

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "aws" {
  region = "us-east-1"
}