output "id" {
  description = "Instance ID"
  value       = aws_instance.this.id
}

output "arn" {
  description = "Instance ARN"
  value       = aws_instance.this.arn
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Public IP address (null if associate_public_ip is false)"
  value       = aws_instance.this.public_ip
}

output "security_group_id" {
  description = "ID of the managed security group"
  value       = aws_security_group.this.id
}
