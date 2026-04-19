output "tunnel_id" {
  description = "Cloudflare tunnel ID"
  value       = cloudflare_tunnel.this.id
}

output "tunnel_name" {
  description = "Cloudflare tunnel name"
  value       = cloudflare_tunnel.this.name
}

output "hostname" {
  description = "Tunnel CNAME hostname — use as the value for DNS records"
  value       = cloudflare_tunnel.this.cname
}

output "cloudflare_zone_id" {
  description = "Cloudflare zone ID"
  value       = data.cloudflare_zones.this.zones[0].id
}
