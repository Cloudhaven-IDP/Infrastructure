



data "aws_lb" "cloudhaven_nlb" {
  name = "cloudhaven-nlb-lb"  
}

data "cloudflare_zone" "this" {
  zone_id = "bd78c44dcf91a8d1510766582aac9c63"
}

locals {
  cloudflare_zone_name = "cloudhaven.work"
  apisix_nlb_hostname  = data.aws_lb.cloudhaven_nlb.dns_name
  cloudhaven_hosts = jsondecode(file("${path.module}/aliases.json"))
  cloudhaven_dns_records = {
    for h in local.cloudhaven_hosts :
    h => {
      type    = "CNAME"
      content = local.apisix_nlb_hostname
      proxied = true
      ttl     = 1 # Auto TTL
    }
  }
}

# # # data.tf
# # locals {
# #   cloudflare_zone_name = "cloudhaven.work"
# #   apisix_nlb_hostname  = data.aws_lb.cloudhaven_nlb.dns_name
# #   cloudhaven_hosts     = jsondecode(file("${path.module}/aliases.json"))
# # }

# # # data "cloudflare_zones" "this" {
# # #   filter {
# # #     name = local.cloudflare_zone_name
# # #   }
# # # }

# # locals {
# #   zone_id = data.cloudflare_zone.this.zone_id
# #   cloudhaven_dns_records = {
# #     for h in local.cloudhaven_hosts :
# #     h => {
# #       type    = "CNAME"
# #       content = local.apisix_nlb_hostname
# #       proxied = true
# #       ttl     = 1
# #     }
# #   }
# # }
