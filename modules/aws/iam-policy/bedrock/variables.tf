variable "policy_name" {
  description = "IAM policy name"
  type        = string
}

variable "description" {
  description = "Policy description"
  type        = string
  default     = "Bedrock InvokeModel access"
}

variable "allowed_models" {
  description = "Foundation model IDs the policy permits (e.g. anthropic.claude-haiku-4-5-20251001-v1:0). Empty means any model. Account-level Bedrock model access is the underlying gate either way."
  type        = list(string)
  default     = []
}

variable "regions" {
  description = "Bedrock regions where the allowed_models are reachable. Ignored when allowed_models is empty."
  type        = list(string)
  default     = ["us-east-1"]
}

variable "inference_profile_arns" {
  description = "Inference profile ARNs to scope this policy to. AWS requires permissions on both the profile and its underlying foundation models, so pass allowed_models alongside this when using cross-region profiles."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
