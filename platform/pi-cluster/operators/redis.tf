resource "helm_release" "redis-operator" {
  name       = "redis-operator"
  repository = "https://ot-container-kit.github.io/helm-charts/"
  chart      = "redis-operator"
  namespace  = "operators"
  create_namespace = true
}