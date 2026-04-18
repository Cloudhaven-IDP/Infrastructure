#------------------------------------------------------------------------------
# Required
#------------------------------------------------------------------------------

variable "zone_id" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "name" {
  description = "DNS record name (e.g. \"argocd\" for argocd.cloudhaven.work)"
  type        = string
}

variable "value" {
  description = "Record value — IP address for A records, hostname for CNAME"
  type        = string
}

#------------------------------------------------------------------------------
# Optional
#------------------------------------------------------------------------------

variable "type" {
  description = "DNS record type: A, CNAME, TXT, MX, etc."
  type        = string
  default     = "CNAME"

  validation {
    condition     = contains(["A", "AAAA", "CNAME", "TXT", "MX", "NS", "SRV"], var.type)
    error_message = "Must be a valid DNS record type."
  }
}

variable "proxied" {
  description = "Whether to proxy traffic through Cloudflare. Required for tunnels. Disables custom TTL."
  type        = bool
  default     = true
}

variable "ttl" {
  description = "TTL in seconds. 1 means auto (used when proxied = true)."
  type        = number
  default     = 1
}
