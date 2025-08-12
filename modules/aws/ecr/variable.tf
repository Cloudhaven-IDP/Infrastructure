variable "name" {
  type = string
}

variable "lifecycle_count" {
  type    = number
  default = null
}

variable "snapshot" {
  type    = bool
  default = false
}

variable "tags" {
  type        = map(string)
  description = "Additional tags on top of default tags"
  default     = {}
}