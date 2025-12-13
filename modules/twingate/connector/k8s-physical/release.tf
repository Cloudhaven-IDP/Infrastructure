resource "helm_release" "twingate-connector" {
  name             = local.release_name
  repository       = "https://twingate.github.io/helm-charts"
  chart            = "connector"
  namespace        = var.namespace
  create_namespace = true

  set = [
    {
      name  = "connector.network"
      value = var.twingate_account
    },
    {
      name  = "connector.existingSecret"
      value = kubernetes_secret_v1.twingate-connector-secret.metadata[0].name
    }
  ]

  values = var.helm_values != null ? [file(var.helm_values)] : []

  depends_on = [
    twingate_connector_tokens.this,
    kubernetes_secret_v1.twingate-connector-secret
  ]
}
