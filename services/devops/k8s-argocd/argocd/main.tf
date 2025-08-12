resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.6"
  create_namespace = true
  values           = [file("${path.module}/values.yaml")]
}

# provider "argocd" {
#   server_addr = "localhost:8080"
#   auth_token  = var.argocd_token
#   insecure    = true
# }

# resource "argocd_application" "k8s_bootstrap" {
#   metadata {
#     name      = "k8s-bootstrap"
#     namespace = "argocd"
#   }

#   spec {
#     project = "default"

#     source {
#       repo_url        = "https://github.com/Cloudhaven-IDP/K8s-Bootstrap"
#       target_revision = "main"
#       path            = "apps"
#     }

#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = "default"
#     }

#     sync_policy {
#       automated {
#         prune    = true
#         self_heal = true
#       }
#     }
#   }
# }
