resource "cloudflare_record" "this" {
  zone_id = var.zone_id
  name    = var.name
  value   = var.value
  type    = var.type
  proxied = var.proxied
  ttl     = var.proxied ? 1 : var.ttl
}
