locals {
  internal_services = [
    "argocd",
    "auth",
    "temporal"
  ]

  ingress_rules = [
    # OIDC discovery for AWS -> tunneled via Cloudflare
    {
      hostname      = "oidc-humboldt.cloudhaven.work"
      path          = "/.well-known/openid-configuration"
      service       = "https://kubernetes.default.svc.cluster.local:443"
      no_tls_verify = true
    },
    {
      hostname      = "oidc-humboldt.cloudhaven.work"
      path          = "/openid/v1/jwks"
      service       = "https://kubernetes.default.svc.cluster.local:443"
      no_tls_verify = true
    },
  ]
}
