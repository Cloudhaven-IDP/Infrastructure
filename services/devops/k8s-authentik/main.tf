#############################
# Data from SSM
#############################
data "aws_ssm_parameter" "authentik_admin_username" {
  name            = "/authentik/admin-username"
  with_decryption = false
}

data "aws_ssm_parameter" "authentik_admin_email" {
  name            = "/authentik/admin-email"
  with_decryption = false
}

data "aws_ssm_parameter" "authentik_domain" {
  name            = "/authentik/domain"
  with_decryption = false
}

#############################
# Locals
#############################
locals {
  admin_username   = lower(data.aws_ssm_parameter.authentik_admin_username.value)
  admin_email      = lower(data.aws_ssm_parameter.authentik_admin_email.value)
  authentik_domain = lower(data.aws_ssm_parameter.authentik_domain.value)
}

#############################
# Generate secrets
#############################
resource "random_password" "authentik_secret_key" {
  length           = 64
  special          = true
  override_special = "_-"
}

resource "random_password" "pg_password" {
  length           = 40
  special          = true
  override_special = "_-"
}

resource "aws_ssm_parameter" "authentik_secret_key" {
  name   = "/authentik/secret-key"
  type   = "SecureString"
  value  = random_password.authentik_secret_key.result
}

resource "aws_ssm_parameter" "pg_password" {
  name   = "/authentik/postgres-password"
  type   = "SecureString"
  value  = random_password.pg_password.result
}

#############################
# Helm release
#############################
resource "helm_release" "authentik" {
  name             = "authentik"
  repository       = "https://charts.goauthentik.io"
  chart            = "authentik"
  namespace        = "authentik"
  create_namespace = false

  values = [templatefile("${path.module}/values.yaml", {
    host        = local.authentik_domain
    admin_user  = local.admin_username
    admin_email = local.admin_email
  })]

  # Inject sensitive values
set_sensitive {
  name  = "postgresql.auth.password"        
  value = random_password.pg_password.result
}

set_sensitive {
  name  = "postgresql.auth.postgresPassword"
  value = random_password.pg_password.result
}

set_sensitive {
  name  = "authentik.postgresql.password" 
  value = random_password.pg_password.result
}


  timeout = 1200
  wait    = true

  depends_on = [
    aws_ssm_parameter.authentik_secret_key,
    aws_ssm_parameter.pg_password
  ]
}

