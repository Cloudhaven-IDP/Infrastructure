resource "helm_release" "twingate_connector" {
  name             = "twingate-connector"
  namespace        = "twingate"
  repository       = "https://twingate.github.io/helm-charts"
  chart            = "connector"
  version          = "0.1.23"
  create_namespace = true

  values = [
    yamlencode({
      connector = {
        network      = local.twingate_network
        accessToken  = local.twingate_access_token
        refreshToken = local.twingate_refresh_token
      }

      podLabels = {
        app = "twingate"
      }

      replicaCount = 2

      resources = {
        limits = {
          cpu    = "200m"
          memory = "256Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }
      }

      podSecurityContext = {
        capabilities = {
          add = ["NET_ADMIN"]
        }
      }
    })
  ]

}
