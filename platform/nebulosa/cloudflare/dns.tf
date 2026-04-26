module "dns_oidc_nebulosa" {
  source = "../../../modules/cloudflare/dns"

  zone_id = module.tunnel.cloudflare_zone_id
  name    = "oidc-nebulosa"
  value   = module.tunnel.hostname
  type    = "CNAME"
  proxied = true
}

module "dns_internal_services" {
  for_each = toset(local.internal_services)
  source   = "../../../modules/cloudflare/dns"

  zone_id = module.tunnel.cloudflare_zone_id
  name    = "${each.key}.internal"
  value   = data.tailscale_device.nebulosa_internal.addresses[0]
  type    = "A"
  proxied = false
}
