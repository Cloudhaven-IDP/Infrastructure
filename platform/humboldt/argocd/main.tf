module "nebulosa_token" {
  source = "../../../modules/argocd/token"

  cluster_name = "nebulosa"

  providers = {
    kubernetes = kubernetes.nebulosa
    aws        = aws
  }
}

module "bootstrapper" {
  source = "../../../modules/argocd/bootstrapper"

  clusters = {
    nebulosa = {
      server  = "https://nebulosa-apiserver.argocd.svc.cluster.local:6443"
      ca_data = base64decode(local.kube["cluster-ca-certificate"])
    }
  }
}
