data "tailscale_device" "this" {
  for_each = var.devices
  hostname = each.key
}

resource "tailscale_device_tags" "this" {
  for_each  = var.devices
  device_id = data.tailscale_device.this[each.key].id
  tags      = each.value
}
