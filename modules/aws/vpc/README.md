# vpc

Creates a VPC with public and private subnets. Wraps `terraform-aws-modules/vpc/aws` with Cloudhaven defaults — DNS enabled, NAT gateway off, flow logs off.

## Usage

```hcl
locals {
  config = yamldecode(file("${path.module}/config.yaml"))
}

module "vpc" {
  source = "../../modules/aws/vpc"

  name        = "humboldt"
  environment = "prod"
  cidr_block  = "10.0.0.0/16"
  azs         = ["us-east-1a", "us-east-1b"]

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = {
    ManagedBy = local.config.managedBy
    Account   = local.config.account
    Network   = local.config.network
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix for all resources | string | - | yes |
| environment | Environment (dev, staging, prod) | string | - | yes |
| cidr_block | CIDR block for the VPC | string | - | yes |
| azs | List of availability zones | list(string) | - | yes |
| public_subnets | CIDR blocks for public subnets | list(string) | `[]` | no |
| private_subnets | CIDR blocks for private subnets | list(string) | `[]` | no |
| enable_dns_support | Enable DNS support | bool | `true` | no |
| enable_dns_hostnames | Enable DNS hostnames | bool | `true` | no |
| tags | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_cidr | CIDR block of the VPC |
| private_subnets | List of private subnet IDs |
| public_subnets | List of public subnet IDs |
| default_security_group_id | Default security group ID |
