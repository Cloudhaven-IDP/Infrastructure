# module "read_policy" {
#   count = var.generate_access_policies ? 1 : 0

#   source       = "../iam_policy/dynamodb"
#   dynamodb     = [{ tableId = module.dynamodb_table.dynamodb_table_id, readonly = true }]
#   kms_key_arns = [module.kms.key_arn, module.kms_replica.key_arn]
# }

# resource "aws_iam_policy" "read" {
#   count       = var.generate_access_policies ? 1 : 0
#   name        = "dynamodb-read-${module.dynamodb_table.dynamodb_table_id}"
#   description = "Read-only access to ${module.dynamodb_table.dynamodb_table_id}"
#   policy      = module.read_policy[0].policy_json
# }

# module "write_policy" {
#   count = var.generate_access_policies ? 1 : 0

#   source       = "../iam_policy/dynamodb"
#   dynamodb     = [{ tableId = module.dynamodb_table.dynamodb_table_id }]
#   kms_key_arns = [module.kms.key_arn, module.kms_replica.key_arn]
# }

# resource "aws_iam_policy" "write" {
#   count       = var.generate_access_policies ? 1 : 0
#   name        = "dynamodb-write-${module.dynamodb_table.dynamodb_table_id}"
#   description = "Write access to ${module.dynamodb_table.dynamodb_table_id}"
#   policy      = module.write_policy[0].policy_json
# }


data "aws_iam_policy_document" "dynamodb_kms_key_policy" {
#   statement {
#     sid    = "Allow access for Key Administrators"
#     effect = "Allow"
#     principals {
#       type        = "AWS"
#       identifiers = [data.aws_iam_role.atlantis.arn]
#     }
#     actions = [
#       "kms:*",
#     ]
#     resources = ["*"]
#   }

  statement {
    sid    = "Allow access through Amazon DynamoDB for all principals in the account that are authorized to use Amazon DynamoDB"
    effect = "Allow"
    principals {
      type        = "AWS"
      # By default, we should delegate dynamodb to grant access for all users in this AWS account
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey",
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["dynamodb.*.amazonaws.com"]
    }
  }
}