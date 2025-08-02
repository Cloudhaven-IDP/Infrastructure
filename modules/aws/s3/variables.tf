###

#add description to each variable and finish readme

###


variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy to create for the S3 bucket"
  type        = string
  default     = null

}

variable "bucket_policy" {
  type        = string
  default     = "{}"
  description = "value of the bucket policy in JSON format. If not provided, no bucket policy will be applied."
}

variable "bucket_logging_target" {
  type    = string
  default = "cloudhaven-logs"
}

variable "bucket_versioning_status" {
  type    = bool
  default = true
}

variable "lifecycle_rule" {
  type    = any
  default = []
}

variable "transition_default_minimum_object_size" {
  type    = string
  default = null
}


variable "intelligent_tiering" {
  type    = any
  default = {}
}

variable "block_public_acl" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
