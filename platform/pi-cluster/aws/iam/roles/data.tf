data "aws_iam_openid_connect_provider" "pi-oidc" {
  url = "https://oidc.cloudhaven.work"
}

data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "external-secrets-role" {
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
      values   = ["system:serviceaccount:operators:external-secrets"]
    }
    condition {
      test     = "StringEquals"
      variable = "oidc.cloudhaven.work:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "gha_deployer_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
         "repo:Cloudhaven-IDP/cloudhaven-agent:*",
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "gha_deployer_policy" {
  statement {
    effect  = "Allow"
    actions = [
        "ecr:*",
    ]
    resources = ["*"] #all repos is fine for now
  }
}