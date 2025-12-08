terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "cloudhaven-tf-bucket-state"
    use_lockfile = true
    key          = "platform/pi-cluster/operators"
    region       = "us-east-1"
  }
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

provider "kubernetes" {
  host = local.kube.host

  client_certificate     = base64decode(local.kube.client_certificate_data)
  client_key             = base64decode(local.kube.client_key_data)
  cluster_ca_certificate = base64decode(local.kube.cluster_ca_certificate_data)
}

locals {
  kube = jsondecode(data.aws_secretsmanager_secret_version.kube_api.secret_string)
}

provider "helm" {
  kubernetes = {
    host                   = local.kube.host
    client_certificate     = base64decode(local.kube.client_certificate_data)
    client_key             = base64decode(local.kube.client_key_data)
    cluster_ca_certificate = base64decode(local.kube.cluster_ca_certificate_data)
  }
}