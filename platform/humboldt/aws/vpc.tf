module "vpc" {
  source = "../../../modules/aws/vpc"

  name        = local.config.cluster
  environment = local.config.environment
  cidr_block  = "10.0.0.0/16"

  # Single AZ — intentionally not fault tolerant (cost optimisation)
  azs = ["us-east-1a"]

  enable_nat_gateway = true

  public_subnets  = ["10.0.1.0/24"]
  private_subnets = ["10.0.101.0/24"]
}
