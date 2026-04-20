terraform {
  required_version = ">= 1.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket  = "cloudhaven-tf-bucket-state"
    key     = "applications/theo/general/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "github" {
  owner = "Cloudhaven-IDP"
}
