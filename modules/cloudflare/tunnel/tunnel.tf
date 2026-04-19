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

        dynamic "origin_request" {
          for_each = ingress_rule.value.no_tls_verify ? [1] : []
          content {
            no_tls_verify = true
          }
        }
      }
    }

    ingress_rule {
      service = "http_status:404"
    }
  }
}

locals {
  labels = merge({
    "app.kubernetes.io/name"      = "cloudflared"
    "app.kubernetes.io/instance"  = var.tunnel_name
    "app.kubernetes.io/component" = "tunnel"
  }, var.additional_labels)
}

resource "kubernetes_deployment" "cloudflared" {
  metadata {
    name      = var.tunnel_name
    namespace = var.namespace
    labels    = local.labels
  }

  spec {
    replicas = 1

    selector {
      match_labels = { "app.kubernetes.io/instance" = var.tunnel_name }
    }

    template {
      metadata {
        labels = local.labels
      }

      spec {
        node_selector = var.node_selector

        container {
          name  = "cloudflared"
          image = "cloudflare/cloudflared:2025.4.0"

          args = [
            "tunnel",
            "--no-autoupdate",
            "run",
            "--token",
            "$(TUNNEL_TOKEN)",
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
    kubernetes_secret.cloudflared_token,
  ]
}
