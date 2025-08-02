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

  enable_nat_gateway = true
  single_nat_gateway = false // one NAT per public subnet

  public_subnet_tags = merge(
    var.tags,
    { "kubernetes.io/role/elb" = "1" }
  )

  private_subnet_tags = merge(
    var.tags,
    { "kubernetes.io/role/internal-elb" = "1" }
  )

  tags = var.tags
}
