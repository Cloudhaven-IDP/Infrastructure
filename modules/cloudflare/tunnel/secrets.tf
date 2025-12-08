resource "random_password" "tunnel_secret" {
  length  = 35
  special = false
}

resource "aws_ssm_parameter" "tunnel_secret" {
  name  = "/cloudflare-tunnel/${var.tunnel_name}/secret"
  type  = "SecureString"
  value = random_password.tunnel_secret.result
}

resource "kubernetes_secret" "cloudflared_token" {
  metadata {
    name      = "cloudflared-token"
    namespace = var.namespace
  }

  data = {
    TUNNEL_TOKEN = cloudflare_tunnel.this.tunnel_token
  }

  type = "Opaque"
}
  