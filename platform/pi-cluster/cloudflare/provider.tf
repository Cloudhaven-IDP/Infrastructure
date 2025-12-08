terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "cloudhaven-tf-bucket-state"
    use_lockfile = true
    key          = "platform/pi-cluster/cloudflare"
    region       = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "cloudflare" {
  api_token = data.aws_ssm_parameter.cloudflare_api_token.value
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host = local.kube.host

  client_certificate     = base64decode(local.kube.client_certificate_data)
  client_key             = base64decode(local.kube.client_key_data)
  cluster_ca_certificate = base64decode(local.kube.cluster_ca_certificate_data)
}

locals {
  config = yamldecode(file("${path.module}/../config.yaml"))
  default_tags = {
    network   = local.config.network
    managedBy = local.config.managedBy
    project   = local.config.project
    region    = local.config.region
    cluster   = local.config.cluster
  }
  kube = jsondecode(data.aws_secretsmanager_secret_version.kube_api.secret_string)
}

data "aws_ssm_parameter" "cloudflare_api_token" {
  name = "/cloudflare/api-token"
}

data "aws_secretsmanager_secret_version" "kube_api" {
  secret_id = "kube-api-info"
}
