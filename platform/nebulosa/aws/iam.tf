module "cert_manager_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "nebulosa-cert-manager"
  oidc_provider_arn    = aws_iam_openid_connect_provider.nebulosa.arn
  cluster              = local.config.cluster
  namespaces           = "cert-manager"
  service_account_name = "cert-manager"
  inline_policy_json   = data.aws_iam_policy_document.cloudflare_ssm.json
}

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

module "qdrant_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "nebulosa-qdrant-external-secrets"
  oidc_provider_arn    = aws_iam_openid_connect_provider.nebulosa.arn
  cluster              = local.config.cluster
  namespaces           = "qdrant"
  service_account_name = "external-secrets"
  inline_policy_json   = data.aws_iam_policy_document.qdrant_ssm.json
}

module "grafana_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "nebulosa-grafana"
  oidc_provider_arn    = aws_iam_openid_connect_provider.nebulosa.arn
  cluster              = local.config.cluster
  namespaces           = "observability"
  service_account_name = "grafana-sa"
  inline_policy_json   = data.aws_iam_policy_document.grafana_ssm.json
}

module "loki_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "nebulosa-loki"
  oidc_provider_arn    = aws_iam_openid_connect_provider.nebulosa.arn
  cluster              = local.config.cluster
  namespaces           = "observability"
  service_account_name = "loki-sa"
  policy_arns = [
    module.loki_chunks.read_write_policy_arn,
  ]
}

module "tailscale_operator_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "nebulosa-tailscale-operator"
  oidc_provider_arn    = aws_iam_openid_connect_provider.nebulosa.arn
  cluster              = local.config.cluster
  namespaces           = "tailscale"
  service_account_name = "operator"
  inline_policy_json   = data.aws_iam_policy_document.tailscale_operator_ssm.json
}

module "arc_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "nebulosa-arc"
  oidc_provider_arn    = aws_iam_openid_connect_provider.nebulosa.arn
  cluster              = local.config.cluster
  namespaces           = "arc"
  service_account_name = "arc-sa"
  inline_policy_json   = data.aws_iam_policy_document.arc_ssm.json
}
