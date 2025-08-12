resource "helm_release" "apisix" {
  name             = "apisix"
  namespace        = "apisix"
  create_namespace = true

  repository = "https://charts.apiseven.com"
  chart      = "apisix"
  version    = "2.9.0"

  values = [file("${path.module}/values.yaml")]
}
