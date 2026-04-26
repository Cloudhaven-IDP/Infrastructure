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

data "aws_ssm_parameter" "qdrant_management_api_key" {
  name            = "/restricted/qdrant/management-api-key"
  with_decryption = false
}

data "aws_ssm_parameter" "tailscale_operator_client_id" {
  name            = "/restricted/tailscale/operator/client-id"
  with_decryption = false
}

data "aws_ssm_parameter" "tailscale_operator_client_secret" {
  name            = "/restricted/tailscale/operator/client-secret"
  with_decryption = false
}

data "aws_iam_policy_document" "tailscale_operator_ssm" {
  statement {
    sid     = "ReadOAuthCredentials"
    effect  = "Allow"
    actions = ["ssm:GetParameter"]
    resources = [
      data.aws_ssm_parameter.tailscale_operator_client_id.arn,
      data.aws_ssm_parameter.tailscale_operator_client_secret.arn,
    ]
  }

  statement {
    sid       = "DecryptSecureString"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:${local.config.region}:*:alias/aws/ssm"]
  }
}

data "aws_iam_policy_document" "qdrant_ssm" {
  statement {
    sid       = "ReadManagementApiKey"
    effect    = "Allow"
    actions   = ["ssm:GetParameter"]
    resources = [data.aws_ssm_parameter.qdrant_management_api_key.arn]
  }

  statement {
    sid       = "DecryptSecureString"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:${local.config.region}:*:alias/aws/ssm"]
  }
}
