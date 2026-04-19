module "dns_argocd" {
  source = "../../../modules/cloudflare/dns"

  zone_id = module.tunnel.cloudflare_zone_id
  name    = "argocd"
  value   = module.tunnel.hostname
  type    = "CNAME"
  proxied = true
}

module "dns_oidc_humboldt" {
  source = "../../../modules/cloudflare/dns"

  zone_id = module.tunnel.cloudflare_zone_id
  name    = "oidc-humboldt"
  value   = module.tunnel.hostname
  type    = "CNAME"
  proxied = true
}
