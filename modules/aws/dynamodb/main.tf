data "aws_caller_identity" "current" {}

locals {
  table_name = join("-", compact([var.service, var.name]))
}

module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 4.0"

  name                             = local.table_name
  attributes                       = var.attributes
  hash_key                         = lookup(var.attributes[0], "name", null)
  range_key                        = length(var.attributes) > 1 ? var.attributes[1].name : null
  billing_mode                     = var.billing_mode
  read_capacity                    = var.read_capacity
  write_capacity                   = var.write_capacity
  ttl_enabled                      = var.ttl_enabled
  ttl_attribute_name               = var.ttl_attribute_name
  point_in_time_recovery_enabled   = var.point_in_time_recovery_enabled
  deletion_protection_enabled      = var.deletion_protection_enabled

  server_side_encryption_enabled   = true
  server_side_encryption_kms_key_arn = module.kms.key_arn

  tags = merge({ Name = local.table_name }, var.tags)
}

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.0"

  aliases      = ["dynamodb/${local.table_name}"]
  multi_region = true
  description  = "KMS key for ${local.table_name}"
  policy       = data.aws_iam_policy_document.dynamodb_kms_key_policy.json
}
