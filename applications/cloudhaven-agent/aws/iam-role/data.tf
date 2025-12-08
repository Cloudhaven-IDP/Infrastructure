data "aws_iam_policy_document" "cloudhaven_agent_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.pi-oidc.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "oidc.cloudhaven.work:sub"
      values   = ["system:serviceaccount:default:cloudhaven-agent"]
    }
    condition {
      test     = "StringEquals"
      variable = "oidc.cloudhaven.work:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_openid_connect_provider" "pi-oidc" {
  url = "https://oidc.cloudhaven.work"
}