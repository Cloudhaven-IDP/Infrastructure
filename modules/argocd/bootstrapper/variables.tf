variable "clusters" {
  description = "Map of cluster name"
  type = map(object({
    server  = string
    ca_data = string
  }))
}
