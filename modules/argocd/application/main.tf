resource "argocd_application" "this" {
  metadata {
    name      = "${var.cluster}.${var.app_name}"
    namespace = "argocd"
  }

  spec {
    project = "default"

    source {
      repo_url        = var.repo_url
      target_revision = var.target_revision
      path            = "${var.cluster}/${var.app_name}"
    }

    destination {
      server    = var.cluster == var.argocd_cluster ? "https://kubernetes.default.svc" : null
      name      = var.cluster != var.argocd_cluster ? var.cluster : null
      namespace = coalesce(var.namespace, var.app_name)
    }

    sync_policy {
      sync_options = ["ServerSideApply=true"]
    }
  }
}
