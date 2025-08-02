output "table_id" {
  value = module.dynamodb_table.dynamodb_table_id
}

output "table_arn" {
  value = module.dynamodb_table.dynamodb_table_arn
}

# output "read_access_policy_arn" {
#   value       = try(aws_iam_policy.read[0].arn, null)
# }

# output "write_access_policy_arn" {
#   value       = try(aws_iam_policy.write[0].arn, null)
# }
