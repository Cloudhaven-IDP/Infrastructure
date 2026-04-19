variable "ingress_rules" {
  description = "List of ingress rules for the Cloudflare tunnel"
  type = list(object({
    service        = string
    hostname       = optional(string)
    path           = optional(string)
    no_tls_verify  = optional(bool, false)
  }))
  default = []
}

variable "tunnel_name" {
  description = "Name of the Cloudflare tunnel"
  type        = string
}

variable "namespace" {
  description = "Namespace for the Cloudflare tunnel"
  type        = string
  default     = "default"
}

variable "cloudflare_account_id" {
  description = "ID of the Cloudflare account"
  type        = string
  sensitive   = true
}

variable "additional_labels" {
  description = "Extra labels to add to the cloudflared Deployment and pod template (e.g. cluster, environment)"
  type        = map(string)
  default     = {}
}