locals {
  internal_services = [
    "langfuse",
    "grafana",
    "loki",
    "victoriametrics",
  ]

  ingress_rules = [
    {
      hostname      = "oidc-nebulosa.cloudhaven.work"
      path          = "/.well-known/openid-configuration"
      service       = "https://kubernetes.default.svc.cluster.local:443"
      no_tls_verify = true
    },
    {
      hostname      = "oidc-nebulosa.cloudhaven.work"
      path          = "/openid/v1/jwks"
      service       = "https://kubernetes.default.svc.cluster.local:443"
      no_tls_verify = true
    },
  ]
}
