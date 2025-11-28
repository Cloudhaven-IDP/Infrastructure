
resource "cloudflare_tunnel" "this" {
  account_id = var.cloudflare_account_id
  name       = var.tunnel_name
  secret     = base64encode(random_password.tunnel_secret.result)
}

resource "cloudflare_tunnel_config" "this" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_tunnel.this.id

  config {
    dynamic "ingress_rule" {
      for_each = var.ingress_rules
      content {
        service  = ingress_rule.value.service
        hostname = ingress_rule.value.hostname
        path     = ingress_rule.value.path
      }
    }

    # Default catch-all rule
    ingress_rule {
      service = "http_status:404"
    }
  }
}

resource "kubernetes_deployment" "cloudflared" {
  metadata {
    name      = var.tunnel_name
    namespace = var.namespace
    labels = {
      app = "cloudflared"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.tunnel_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.tunnel_name
        }
      }

      spec {
        container {
          name  = "cloudflared"
          image = "cloudflare/cloudflared:latest"

          args = [
            "tunnel",
            "--no-autoupdate",
            "run",
            "--token",
            "$(TUNNEL_TOKEN)"
          ]

          env {
            name = "TUNNEL_TOKEN"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.cloudflared_token.metadata[0].name
                key  = "TUNNEL_TOKEN"
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    cloudflare_tunnel_config.this,
    cloudflare_tunnel.this,
    kubernetes_secret.cloudflared_token
  ]
}

