data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "tls_certificate" "k3s_oidc" {
  url = "https://oidc.cloudhaven.work"
}
