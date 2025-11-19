terraform {
    backend "s3" {
    encrypt        = true
    bucket         = "cloudhaven-tf-bucket-state"
    use_lockfile   = true
    key            = "public-repos"
    region         = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }

    github = {
      source  = "integrations/github"
      version = ">= 5.0"
    }
  }

  required_version = ">= 1.5"
}

provider "github" {
  owner = "Cloudhaven-IDP"
}