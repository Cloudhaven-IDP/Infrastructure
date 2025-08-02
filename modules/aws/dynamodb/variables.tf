
variable "name" {
  description = "Optional suffix for the DynamoDB table name"
  type        = string
  default     = null
}

variable "service" {
  description = "Service that this DynamoDB table belongs to"
  type        = string
  default     = null

}
variable "generate_access_policies" {
  description = "Whether to generate read/write IAM policies"
  type        = bool
  default     = true
}

variable "atlantis_role_name" {
  description = "IAM role name for Atlantis to attach policies"
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of attribute definitions (name/type)"
  type        = list(object({ name = string, type = string }))
  default     = []
}

variable "billing_mode" {
  description = "PROVISIONED or PAY_PER_REQUEST"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  description = "Read capacity units (if PROVISIONED)"
  type        = number
  default     = null
}

variable "write_capacity" {
  description = "Write capacity units (if PROVISIONED)"
  type        = number
  default     = null
}

variable "ttl_enabled" {
  description = "Enable TTL"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "Attribute name for TTL timestamp"
  type        = string
  default     = ""
}

variable "deletion_protection_enabled" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "point_in_time_recovery_enabled" {
  description = "Enable point-in-time recovery"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}

variable "principals_kms_allowed_via_dynamodb" {
  description = "Principals that are allowed to use KMS via dynamoDB. By default, we delegate dynamodb to grant access for all users in this AWS account. For very restrictive cases where highly sensitive data (e.g. data tokenization) is involved, we restrict the principals allowed via dynamodb to this key as well (should you do this, please be wary of cyclic dependency between the role and the KMS policy)."
  type        = list(string)
  default     = null # ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
}