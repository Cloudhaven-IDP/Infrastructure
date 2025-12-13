terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "cloudhaven-tf-bucket-state"
    use_lockfile = true
    key          = "twingate/network/network"
    region       = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    twingate = {
      source  = "twingate/twingate"
      version = ">= 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "helm" {
  kubernetes = {
    host                   = local.kube.host
    client_certificate     = base64decode(local.kube.client_certificate_data)
    client_key             = base64decode(local.kube.client_key_data)
    cluster_ca_certificate = base64decode(local.kube.cluster_ca_certificate_data)
  }
}

provider "kubernetes" {
  host = local.kube.host

  client_certificate     = base64decode(local.kube.client_certificate_data)
  client_key             = base64decode(local.kube.client_key_data)
  cluster_ca_certificate = base64decode(local.kube.cluster_ca_certificate_data)
}


provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = local.default_tags
  }
}

provider "twingate" {
  api_token = data.aws_ssm_parameter.twingate_api_token.value
  network   = local.config.account
  default_tags = {
    tags = local.default_tags
  }
}

