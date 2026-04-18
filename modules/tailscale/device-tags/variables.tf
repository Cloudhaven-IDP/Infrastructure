variable "devices" {
  description = "Map of device hostname to its Tailscale tags"
  type        = map(list(string))
}
