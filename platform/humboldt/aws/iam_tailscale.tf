module "tailscale_operator_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "humboldt-tailscale-operator"
  oidc_provider_arn    = aws_iam_openid_connect_provider.humboldt.arn
  cluster              = "humboldt"
  namespace            = "tailscale"
  service_account_name = "tailscale-operator"
  inline_policy_json   = data.aws_iam_policy_document.tailscale_operator_ssm.json
}
