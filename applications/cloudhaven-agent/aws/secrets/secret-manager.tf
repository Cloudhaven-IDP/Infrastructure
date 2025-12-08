module "secrets_manager" {
  source = "terraform-aws-modules/secrets-manager/aws"

  name                    = "cloudhaven-agent-secrets"
  description             = "Cloudhaven Agent Secrets Manager secrets"
  recovery_window_in_days = 30

  # Secret value placeholder... module wouldn't work without it
  secret_string = jsonencode({})

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

  tags = {
    Environment = "Production"
  }
}

data "aws_iam_role" "external-secrets-role" {
  name = "external-secrets-role"
}
