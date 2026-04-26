module "dns_oidc_nebulosa" {
  source = "../../../modules/cloudflare/dns"

  zone_id = module.tunnel.cloudflare_zone_id
  name    = "oidc-nebulosa"
  value   = module.tunnel.hostname
  type    = "CNAME"
  proxied = true
}

module "dns_langfuse_internal" {
  source = "../../../modules/cloudflare/dns"

  zone_id = module.tunnel.cloudflare_zone_id
  name    = "langfuse.internal"
  value   = "100.85.33.92"
  type    = "A"
  proxied = false
}
