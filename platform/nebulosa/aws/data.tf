data "tls_certificate" "nebulosa_oidc" {
  url = "https://oidc-nebulosa.cloudhaven.work"
}

data "aws_iam_policy_document" "external_secrets_sm" {
  statement {
    sid    = "SecretsManagerReadWrite"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecrets",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecret",
      "secretsmanager:TagResource",
    ]
    resources = ["*"]
  }
}
