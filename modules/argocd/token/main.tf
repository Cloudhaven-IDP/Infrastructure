resource "kubernetes_service_account" "argocd_manager" {
  metadata {
    name      = "argocd-manager"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "argocd_manager" {
  metadata {
    name = "argocd-manager"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.argocd_manager.metadata[0].name
    namespace = kubernetes_service_account.argocd_manager.metadata[0].namespace
  }
}

resource "kubernetes_secret" "argocd_manager_token" {
  metadata {
    name      = "argocd-manager-token"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.argocd_manager.metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"

  depends_on = [kubernetes_service_account.argocd_manager]
}

data "kubernetes_secret" "argocd_manager_token" {
  metadata {
    name      = kubernetes_secret.argocd_manager_token.metadata[0].name
    namespace = kubernetes_secret.argocd_manager_token.metadata[0].namespace
  }
}

resource "aws_ssm_parameter" "token" {
  name  = "/restricted/argocd/${var.cluster_name}/token"
  type  = "SecureString"
  value = data.kubernetes_secret.argocd_manager_token.data["token"]
}
