terraform {
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
    
    required_version = ">= 0.12"
}