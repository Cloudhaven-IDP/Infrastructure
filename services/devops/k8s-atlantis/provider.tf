terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }

  backend "s3" {
    bucket         = "cloudhaven-tf-state"
    key            = "services/devops/atlantis/atlantis"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "devops-tf-state-lock"
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

