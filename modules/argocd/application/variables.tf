variable "cluster" {
  type = string
}

variable "app_name" {
  type = string
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
