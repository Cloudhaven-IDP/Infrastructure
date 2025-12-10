module "external-secrets-role" {
  source = "../../../../../modules/aws/iam/role"

  role_name = "external-secrets-role"

  description        = "IAM role for External Secrets operator to access AWS Secrets Manager"
  assume_role_policy = data.aws_iam_policy_document.external-secrets-role.json

  managed_policies = [
    "AWSSecretsManagerClientReadOnlyAccess"
  ]

}
