data "aws_ssoadmin_instances" "this" {}
data "aws_sts" "name" {

}

locals {
  identity_store_id = data.aws_ssoadmin_instances.this.identity_store_ids[0]
  instance_arn      = data.aws_ssoadmin_instances.this.arns[0]

  inline_policies = compact([
    var.inline_policy,
    var.access_restricted_ssm ? null : data.aws_iam_policy_document.deny_restricted[0].json
  ])
}

data "aws_iam_policy_document" "deny_restricted" {
  count = var.access_restricted_ssm ? 0 : 1

  statement {
    sid       = "PathDeny"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["arn:aws:ssm:*:*:parameter/restricted/*"]
  }
}