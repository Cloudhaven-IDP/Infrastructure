resource "random_password" "qdrant_api_key" {
    length = 32
    special = false
}

module "qdrant_secrets" {
  source = "terraform-aws-modules/secrets-manager/aws"

  name                    = "qdrant"
  description             = "Qdrant Secrets Manager secrets"
  recovery_window_in_days = 30


  secret_string = jsonencode({
    api-key = random_password.qdrant_api_key.result
  })

  create_policy       = true
  block_public_policy = true

  policy_statements = {
    allow_eso_read = {
      sid       = "AllowESOread"
      effect    = "Allow"
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
      principals = [
        {
          type        = "AWS"
          identifiers = [data.aws_iam_role.external-secrets-role.arn]
        }
      ]
    }
  }
}

