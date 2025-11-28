output "tunnel_id" {
  description = "ID of the Cloudflare tunnel"
  value       = cloudflare_tunnel.this.id
}

output "tunnel_name" {
  description = "Name of the Cloudflare tunnel"
  value       = cloudflare_tunnel.this.name
}

output "hostname" {
  description = "Hostname of the Cloudflare tunnel"
  value       = cloudflare_tunnel.this.cname
}

output "cloudflare_zone_id" {
  description = "ID of the Cloudflare zone"
  value       = data.cloudflare_zones.this.zones[0].id
}