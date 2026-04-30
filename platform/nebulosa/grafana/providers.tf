terraform {
  required_version = ">= 1.5"

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "cloudhaven-tf-bucket-state"
    key     = "platform/nebulosa/grafana/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

locals {
  config = yamldecode(file("${path.module}/../config.yaml"))
  internal_domain = "internal.cloudhaven.work"
}

provider "aws" {
  region = local.config.region
}

provider "grafana" {
  url  = "https://grafana.${local.internal_domain}"
  auth = "${data.aws_ssm_parameter.grafana_admin_user.value}:${data.aws_ssm_parameter.grafana_admin_password.value}"
}
