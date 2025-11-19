variable "twingate_network" {
  type        = string
  description = "Twingate network name (from the admin console)"
}

variable "connector_name" {
  type        = string
  description = "Connector name"
}

variable "values_file" {
  type        = string
  description = "Path to values file"
  default     = null
}
