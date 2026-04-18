module "device_tags" {
  source = "../../../modules/tailscale/device-tags"

  devices = {
    "pi-1" = ["tag:k8s-cp"]
    "pi-2" = ["tag:k8s-worker"]
    "pi-3" = ["tag:k8s-worker"]
  }
}
