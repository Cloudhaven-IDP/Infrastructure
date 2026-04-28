locals {
  system_apps = [
    "langfuse",
    "action-scale-set",
  ]

  app_namespace_overrides = {
    "action-scale-set" = "arc"
  }
}

module "system_apps" {
  for_each = toset(local.system_apps)
  source   = "../../../modules/argocd/application"

  cluster   = local.config.cluster
  app_name  = each.key
  namespace = lookup(local.app_namespace_overrides, each.key, null)
}
