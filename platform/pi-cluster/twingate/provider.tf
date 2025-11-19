terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "cloudhaven-tf-bucket-state"
    use_lockfile   = true
    key            = "twingate/network/network"
    region         = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    twingate = {
      source  = "twingate/twingate"
      version = "~> 1.0"
    }
  }
  required_version = ">= 1.0"
}

provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = local.default_tags
  }
}

provider "twingate" {
  api_token = data.aws_ssm_parameter.twingate_api_token.value
  network   = local.config.project
}

data "aws_ssm_parameter" "twingate_api_token" {
  name = "/twingate/api-token"
}

locals {
  config = yamldecode(file("${path.module}/../config.yaml"))
  default_tags = {
    network     = local.config.network
    managedBy  = local.config.managedBy
    project     = local.config.project
    region      = local.config.region
    cluster     = local.config.cluster
  }
}