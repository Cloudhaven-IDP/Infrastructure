output "role_arn" {
  description = "IAM role ARN — annotate the Kubernetes service account with this"
  value       = module.role.role_arn
}

output "role_name" {
  description = "IAM role name"
  value       = module.role.role_name
}
