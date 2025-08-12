terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "cloudhaven-tf-state"
    dynamodb_table = "devops-tf-state-lock"
    key            = "services/devops/argocd/argocd-server"
    region         = "us-east-1"
  }

  required_providers {
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

# provider "argocd" {
#   server_addr = "localhost:8080"
#   auth_token  = var.argocd_token
#   insecure    = true
# }


