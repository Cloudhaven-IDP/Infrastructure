output "arn" {
  description = "ARN of the IAM policy. Attach to a role via policy_arns = [module.bedrock_<agent>.arn]"
  value       = aws_iam_policy.this.arn
}

output "name" {
  description = "Name of the IAM policy"
  value       = aws_iam_policy.this.name
}
