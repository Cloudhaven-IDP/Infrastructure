data "aws_iam_policy_document" "default_policy" {
  statement {
    sid       = "DenyUnSecureCommunications"
    effect    = "Deny"
    resources = ["arn:aws:s3:::${var.bucket_name}"]
    actions   = ["s3:*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}


data "aws_iam_policy_document" "combined" {
  source_policy_documents = compact([
    data.aws_iam_policy_document.default_policy.json,
    try(var.bucket_policy, "")
  ])
}
