output "record_id" {
  description = "Cloudflare DNS record ID"
  value       = cloudflare_record.this.id
}

output "hostname" {
  description = "Fully qualified hostname"
  value       = cloudflare_record.this.hostname
}
