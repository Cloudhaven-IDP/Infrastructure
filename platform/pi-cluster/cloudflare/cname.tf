resource "cloudflare_record" "this" {
  for_each = toset(local.cnames)
  zone_id  = module.pi-tunnel.cloudflare_zone_id
  name     = each.value
  value    = module.pi-tunnel.hostname
  type     = "CNAME"
  proxied  = true
}

locals {
  cnames = [
    "argocd",
  ]
}