module "tailscale_operator_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "humboldt-tailscale-operator"
  oidc_provider_arn    = aws_iam_openid_connect_provider.humboldt.arn
  cluster              = "humboldt"
  namespaces           = "tailscale"
  service_account_name = "operator"
  inline_policy_json   = data.aws_iam_policy_document.tailscale_operator_ssm.json
}

module "ebs_csi_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "humboldt-ebs-csi-controller"
  oidc_provider_arn    = aws_iam_openid_connect_provider.humboldt.arn
  cluster              = "humboldt"
  namespaces           = "kube-system"
  service_account_name = "ebs-csi-controller-sa"
  policy_arns          = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
}

module "cert_manager_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "humboldt-cert-manager"
  oidc_provider_arn    = aws_iam_openid_connect_provider.humboldt.arn
  cluster              = local.config.cluster
  namespaces           = "cert-manager"
  service_account_name = "cert-manager"
  inline_policy_json   = data.aws_iam_policy_document.cloudflare_ssm.json
}

module "external_secrets_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "humboldt-external-secrets-operator"
  oidc_provider_arn    = aws_iam_openid_connect_provider.humboldt.arn
  cluster              = local.config.cluster
  namespaces           = "external-secrets"
  service_account_name = "external-secrets-sa"
  inline_policy_json   = data.aws_iam_policy_document.external_secrets_sm.json
}
