module "external-secrets-role" {
  source = "../../../../../modules/aws/iam/role"

  role_name = "external-secrets-role"

  description        = "IAM role for External Secrets operator to access AWS Secrets Manager"
  assume_role_policy = data.aws_iam_policy_document.external-secrets-role.json

  managed_policies = [
    "AWSSecretsManagerClientReadOnlyAccess"
  ]

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
