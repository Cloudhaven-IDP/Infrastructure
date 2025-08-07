resource "cloudflare_dns_record" "this" {
  for_each = local.cloudhaven_dns_records

  zone_id = "bd78c44dcf91a8d1510766582aac9c63"
  name    = each.key
  type    = each.value.type
  content = each.value.content
  ttl     = 1
  proxied = true
}
