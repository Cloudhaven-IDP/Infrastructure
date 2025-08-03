variable "values" {
  description = "List of values to be passed to the ArgoCD Helm chart"
  type        = list(string)
  default     = []
  
}

