output "device_ids" {
  description = "Map of hostname to Tailscale device ID"
  value       = { for k, v in data.tailscale_device.this : k => v.id }
}
