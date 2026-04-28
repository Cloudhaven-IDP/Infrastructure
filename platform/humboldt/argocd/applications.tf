module "system_apps" {
  for_each = toset(local.system_apps)
  source   = "../../../modules/argocd/application"

  cluster  = local.config.cluster
  app_name = each.key
}
