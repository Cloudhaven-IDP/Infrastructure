variable "role_name" {
  type        = string
  description = "Name of the IAM role. Required if role_name_prefix is not provided."
  default     = null
  validation {
    condition     = var.role_name != null
    error_message = "Role_name must be provided"
  }
}

variable "path" {
  type        = string
  description = "Path to the IAM role"
  default     = "/"
}

variable "description" {
  type        = string
  description = "Description of the IAM role"
  default     = null
}

variable "assume_role_policy" {
  type        = string
  description = "JSON assume role policy document. If not provided, will be generated from principals variable. Required if principals is not provided."
  default     = null
}

variable "principals" {
  type = object({
    type        = string # Service, AWS, Federated, etc.
    identifiers = list(string)
  })
  description = "Principal configuration for assume role policy. Ignored if assume_role_policy is provided"
  default     = null
}

variable "max_session_duration" {
  type        = number
  description = "Maximum session duration in seconds (3600-43200)"
  default     = 3600
  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Max session duration must be between 3600 and 43200 seconds"
  }
}

variable "managed_policies" {
  type        = list(string)
  description = "List of AWS managed policy ARNs to attach"
  default     = []
}

variable "inline_policies" {
  type = map(object({
    policy = string # JSON policy document
  }))
  description = "Map of inline policy names to policy documents"
  default     = {}
}

variable "create_instance_profile" {
  type        = bool
  description = "Whether to create an instance profile for EC2 use cases"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the IAM role"
  default     = {}
}

variable "force_detach_policies" {
  type        = bool
  description = "Whether to force detach policies when destroying the role"
  default     = false
}

