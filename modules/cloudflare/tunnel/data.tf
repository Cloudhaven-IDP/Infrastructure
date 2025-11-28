data "cloudflare_zones" "this" {
  filter {
    name = "cloudhaven.work"
  }
}

locals {
  zone_id = data.cloudflare_zones.this.zones[0].id
}

