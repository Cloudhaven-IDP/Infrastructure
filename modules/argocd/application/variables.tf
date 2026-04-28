variable "cluster" {
  type = string
}

variable "app_name" {
  type = string
}

variable "namespace" {
  description = "Destination namespace for the ArgoCD Application. Defaults to app_name when null."
  type        = string
  default     = null
}

variable "argocd_cluster" {
  type    = string
  default = "humboldt"
}

variable "repo_url" {
  type    = string
  default = "https://github.com/Cloudhaven-IDP/K8s-Bootstrap"
}

variable "target_revision" {
  type    = string
  default = "main"
}
