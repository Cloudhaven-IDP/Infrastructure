module "tailscale_operator_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "humboldt-tailscale-operator"
  oidc_provider_arn    = aws_iam_openid_connect_provider.humboldt.arn
  cluster              = "humboldt"
  namespace            = "tailscale"
  service_account_name = "operator"
  inline_policy_json   = data.aws_iam_policy_document.tailscale_operator_ssm.json
}

module "ebs_csi_role" {
  source = "../../../modules/aws/iam/app_role"

  role_name            = "humboldt-ebs-csi-controller"
  oidc_provider_arn    = aws_iam_openid_connect_provider.humboldt.arn
  cluster              = "humboldt"
  namespace            = "kube-system"
  service_account_name = "ebs-csi-controller-sa"
  policy_arns          = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
}
