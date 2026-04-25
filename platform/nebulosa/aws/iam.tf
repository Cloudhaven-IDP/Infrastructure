module "external_secrets_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "nebulosa-external-secrets-operator"
  oidc_provider_arn    = aws_iam_openid_connect_provider.nebulosa.arn
  cluster              = local.config.cluster
  namespaces           = "external-secrets"
  service_account_name = "external-secrets-sa"
  inline_policy_json   = data.aws_iam_policy_document.external_secrets_sm.json
}

module "langfuse_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "nebulosa-langfuse"
  oidc_provider_arn    = aws_iam_openid_connect_provider.nebulosa.arn
  cluster              = local.config.cluster
  namespaces           = "langfuse"
  service_account_name = "langfuse-sa"
  policy_arns = [
    module.langfuse_secret.read_policy_arn,
    module.langfuse_blobs.read_write_policy_arn,
  ]
}
