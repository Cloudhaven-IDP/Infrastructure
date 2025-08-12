resource "helm_release" "atlantis" {
  name             = "atlantis"
  namespace        = "atlantis"
  create_namespace = true
  repository       = "https://runatlantis.github.io/helm-charts"
  chart            = "atlantis"
  version          = "4.17.0"

  values = [file("${path.module}/values.yaml")]
}