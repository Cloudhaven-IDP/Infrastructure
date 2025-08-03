output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "security_group_id" {
  description = "Security group ID for the VPC"
  value       = module.vpc.default_security_group_id
  
}