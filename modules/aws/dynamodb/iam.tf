
locals {
  table_name = join("-", compact([var.service, var.name]))
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "dynamodb_kms_key_policy" {
  statement {
    sid    = "AllowRootAccountAccess"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowDynamoDBAccess"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
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
