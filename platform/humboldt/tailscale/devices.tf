locals {
  nebulosa_devices = {
    pi-1 = { tags = ["tag:k8s-cp"] }
    pi-2 = { tags = ["tag:k8s-worker"] }
    pi-3 = { tags = ["tag:k8s-worker"] }
  }
}

data "tailscale_device" "nebulosa" {
  for_each = local.nebulosa_devices
  hostname = each.key
}

resource "tailscale_device_tags" "nebulosa" {
  for_each  = local.nebulosa_devices
  device_id = data.tailscale_device.nebulosa[each.key].id
  tags      = each.value.tags

  depends_on = [tailscale_acl.this]
}
