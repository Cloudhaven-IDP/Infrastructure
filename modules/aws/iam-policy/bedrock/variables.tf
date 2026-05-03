variable "policy_name" {
  description = "IAM policy name"
  type        = string
}

variable "description" {
  description = "Policy description"
  type        = string
  default     = "Bedrock InvokeModel access"
}

variable "model_ids" {
  description = "Foundation model IDs to allow (e.g. anthropic.claude-haiku-4-5-20251001-v1:0). Empty list = Resource: \"*\" — relies on AWS account-level model access list as the gate."
  type        = list(string)
  default     = []
}

variable "regions" {
  description = "Bedrock regions where the listed models are reachable. Ignored when model_ids is empty."
  type        = list(string)
  default     = ["us-east-1"]
}

variable "allow_list_models" {
  description = "Also grant ListFoundationModels + GetFoundationModel — useful for callers that need to discover available models at runtime."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
