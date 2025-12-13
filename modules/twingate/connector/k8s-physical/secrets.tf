resource "kubernetes_secret_v1" "twingate-connector-secret" {
  metadata {
    name      = var.secret_name != null ? var.secret_name : "twingate-connector-secret"
    namespace = var.namespace
    annotations = {
      "meta.helm.sh/release-name"      = local.release_name
      "meta.helm.sh/release-namespace" = var.namespace
    }
  }

  type = "Opaque"

  data = {
    TWINGATE_ACCESS_TOKEN  = twingate_connector_tokens.this.access_token
    TWINGATE_REFRESH_TOKEN = twingate_connector_tokens.this.refresh_token
  }
  depends_on = [
    twingate_connector_tokens.this
  ]
}