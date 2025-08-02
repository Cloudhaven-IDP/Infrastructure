output "instance_id" {
  description = "Instance ID"
  value       = module.ec2_instance.id
}
output "public_ip" {
  description = "Public IP (if applicable)"
  value       = try(module.ec2_instance, null)
}

output "private_ip" {
  description = "Private IP address"
  value       = module.ec2_instance.private_ip
}

output "arn" {
  description = "Instance ARN"
  value       = module.ec2_instance.arn
}
