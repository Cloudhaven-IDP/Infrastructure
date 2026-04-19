module "tunnel" {
  source = "../../../modules/cloudflare/tunnel"

  tunnel_name           = "humboldt"
  namespace             = "argocd"
  cloudflare_account_id = data.aws_ssm_parameter.cloudflare_account_id.value
  ingress_rules         = local.ingress_rules

  additional_labels = {
    "app.kubernetes.io/managed-by"   = "terraform"
  }
}