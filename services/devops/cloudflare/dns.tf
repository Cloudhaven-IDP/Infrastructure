########################
# Records
########################
resource "cloudflare_dns_record" "app" {
  for_each = local.cloudhaven_dns_records

  zone_id = "${data.cloudflare_zone.this.zone_id}"
  name    = "${each.key}.${local.cloudflare_zone_name}"
  type    = each.value.type
  content = each.value.content
  proxied = each.value.proxied
  ttl     = each.value.ttl
}