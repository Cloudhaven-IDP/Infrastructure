#------------------------------------------------------------------------------
# Required
#------------------------------------------------------------------------------

variable "role_name" {
  description = "IAM role name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider (aws_iam_openid_connect_provider)"
  type        = string
}

variable "namespaces" {
  description = "Kubernetes namespace(s) the service account lives in — comma-separated, supports wildcards"
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes service account name allowed to assume this role"
  type        = string
}

#------------------------------------------------------------------------------
# OIDC URL — provide either cluster or oidc_provider_url (not both)
#------------------------------------------------------------------------------

variable "cluster" {
  description = "Cluster name — derives OIDC URL as oidc-<cluster>.<domain> (e.g. humboldt → oidc-humboldt.cloudhaven.work)"
  type        = string
  default     = null
}

variable "domain" {
  description = "Base domain for OIDC URLs — only used when cluster is set"
  type        = string
  default     = "cloudhaven.work"
}

variable "oidc_provider_url" {
  description = "Explicit OIDC provider hostname without https:// — use when cluster-based derivation doesn't apply"
  type        = string
  default     = null
}

#------------------------------------------------------------------------------
# Optional
#------------------------------------------------------------------------------

variable "policy_arns" {
  description = "List of managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "inline_policy_json" {
  description = "Inline policy JSON to attach to the role — use for bespoke permissions"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
