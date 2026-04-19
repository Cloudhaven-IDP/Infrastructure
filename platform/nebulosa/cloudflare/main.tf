resource "kubernetes_namespace" "cloudflare" {
  metadata {
    name = "cloudflare"
  }
}

module "tunnel" {
  source = "../../../modules/cloudflare/tunnel"

  tunnel_name           = "nebulosa"
  namespace             = "cloudflare"
  cloudflare_account_id = data.aws_ssm_parameter.cloudflare_account_id.value
  ingress_rules         = local.ingress_rules

  additional_labels = {
    "app.kubernetes.io/managed-by" = "terraform"
  }

  node_selector = {
    "kubernetes.io/hostname" = "pi-1"
  }
}
