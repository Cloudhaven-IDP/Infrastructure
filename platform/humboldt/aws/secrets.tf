module "authentik_bootstrap_secret" {
  source = "../../../modules/aws/secrets-manager"

  name        = "/authentik/bootstrap"
  description = "Authentik bootstrap"
}

module "authentik_oidc_client_secrets" {
  source = "../../../modules/aws/secrets-manager"

  name        = "/authentik/oidc-clients"
  description = "Per-application OIDC client_secret values"
}
