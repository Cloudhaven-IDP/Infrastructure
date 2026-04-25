data "aws_ssm_parameter" "tailscale_auth_key" {
  name            = "/restricted/tailscale/auth-key"
  with_decryption = false # EC2 fetches the value at boot — we only need the ARN here
}

data "aws_ssm_parameter" "tailscale_operator_client_id" {
  name            = "/restricted/tailscale/operator/client-id"
  with_decryption = false
}

data "aws_ssm_parameter" "tailscale_operator_client_secret" {
  name            = "/restricted/tailscale/operator/client-secret"
  with_decryption = false
}

data "tls_certificate" "humboldt_oidc" {
  url = "https://oidc-humboldt.cloudhaven.work"
}

data "aws_ami" "al2023_arm" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

#------------------------------------------------------------------------------
# Tailscale IAM policy
#------------------------------------------------------------------------------

data "aws_iam_policy_document" "tailscale_ssm" {
  statement {
    sid       = "ReadParameter"
    effect    = "Allow"
    actions   = ["ssm:GetParameter"]
    resources = [data.aws_ssm_parameter.tailscale_auth_key.arn]
  }

  statement {
    sid       = "DecryptParameter"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:${local.config.region}:*:alias/aws/ssm"]
  }
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

data "aws_iam_policy_document" "tailscale_operator_ssm" {
  statement {
    sid     = "ReadParameters"
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
