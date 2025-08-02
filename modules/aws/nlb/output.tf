output "nlb_dns_name" {
  description = "DNS name of the NLB"
  value       = aws_lb.this.dns_name
}

output "nlb_arn" {
  description = "ARN of the NLB"
  value       = aws_lb.this.arn
}