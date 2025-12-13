variable "twingate_network_name" {
  type        = string
  description = "Twingate remote network name (from the admin console)"
}

variable "twingate_account" {
  type        = string
  description = "Twingate account/tenant name (e.g., 'cloudhaven' from cloudhaven.twingate.com)"
}

variable "connector_name" {
  type        = string
  description = "Connector name"
}

variable "release_name" {
  type        = string
  description = "Release name"
  default     = null
}

variable "helm_values" {
  type        = string
  description = "Path to values file"
  default     = null
}

variable "secret_name" {
  type        = string
  description = "Name of the Kubernetes secret"
  default     = null
}

variable "namespace" {
  type        = string
  description = "Namespace for the Helm release"
  default     = "twingate-connector"
}