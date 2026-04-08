locals {
  tags = merge({
    Name        = var.name
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name            = var.name
  cidr            = var.cidr_block
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.enable_nat_gateway
  enable_flow_log    = false

  public_subnet_tags  = local.tags
  private_subnet_tags = local.tags

  tags = local.tags
}
