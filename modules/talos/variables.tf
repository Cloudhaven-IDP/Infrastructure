#------------------------------------------------------------------------------
# Required
#------------------------------------------------------------------------------

variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.cluster_name))
    error_message = "Cluster name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}

variable "vpc_id" {
  description = "VPC ID — cluster resources are created here"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for cluster nodes. Control plane and workers are spread across these."
  type        = list(string)
}

#------------------------------------------------------------------------------
# Control plane
#------------------------------------------------------------------------------

variable "control_plane_instance_type" {
  description = "EC2 instance type for control plane nodes"
  type        = string
  default     = "t3.medium"
}

variable "control_plane_count" {
  description = "Number of control plane nodes (odd number)"
  type        = number
  default     = 1

  validation {
    condition     = var.control_plane_count >= 1 && var.control_plane_count % 2 == 1
    error_message = "Control plane count must be an odd number >= 1."
  }
}

variable "control_plane_volume_size" {
  description = "Root volume size in GB for control plane nodes"
  type        = number
  default     = 50
}

#------------------------------------------------------------------------------
# Workers (ASG)
#------------------------------------------------------------------------------

variable "worker_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.large"
}

variable "worker_min" {
  description = "Minimum number of worker nodes in the ASG"
  type        = number
  default     = 1
}

variable "worker_max" {
  description = "Maximum number of worker nodes in the ASG (cluster autoscaler ceiling)"
  type        = number
  default     = 5
}

variable "worker_desired" {
  description = "Desired number of worker nodes in the ASG"
  type        = number
  default     = 2
}

variable "worker_volume_size" {
  description = "Root volume size in GB for worker nodes"
  type        = number
  default     = 100
}

#------------------------------------------------------------------------------
# Talos / Kubernetes versions
#------------------------------------------------------------------------------

variable "talos_version_contract" {
  description = "Talos API version contract. If null, uses the version shipped with the provider."
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "Kubernetes version. If null, uses the version shipped with the Talos SDK."
  type        = string
  default     = null
}

#------------------------------------------------------------------------------
# Network access
#------------------------------------------------------------------------------

variable "talos_api_allowed_cidrs" {
  description = "CIDRs allowed to reach Talos API (port 50000). Include Tailscale CIDR and VPC CIDR when using subnet router (subnet router SNATs traffic, so source IP is a VPC IP)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "kubernetes_api_allowed_cidrs" {
  description = "CIDRs allowed to reach Kubernetes API (port 6443). Include VPC CIDR when using Tailscale subnet router (SNAT means source IP is a VPC IP)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "additional_api_ingress_rules" {
  description = "Additional ingress rules for the Kubernetes API security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
  }))
  default = []
}

variable "associate_public_ip" {
  description = "Associate public IPs with cluster nodes. Set false when using Tailscale-only access."
  type        = bool
  default     = true
}

#------------------------------------------------------------------------------
# NLB (optional — use Cloudflare Tunnel or Tailscale instead)
#------------------------------------------------------------------------------

variable "enable_nlb" {
  description = "Create an NLB for the Kubernetes API. Disable if using Cloudflare Tunnel or Tailscale."
  type        = bool
  default     = false
}

#------------------------------------------------------------------------------
# Config patches
#------------------------------------------------------------------------------

variable "config_patches" {
  description = "List of Talos machine config patches (YAML strings) applied to ALL nodes"
  type        = list(string)
  default     = []
}

variable "control_plane_config_patches" {
  description = "List of Talos machine config patches (YAML strings) applied to control plane nodes only"
  type        = list(string)
  default     = []
}

variable "worker_config_patches" {
  description = "List of Talos machine config patches (YAML strings) applied to worker nodes only"
  type        = list(string)
  default     = []
}

#------------------------------------------------------------------------------
# Optional
#------------------------------------------------------------------------------

variable "ami_id" {
  description = "Override the Talos AMI. If null, latest official Sidero Labs AMI is looked up for var.architecture."
  type        = string
  default     = null

  validation {
    condition     = var.ami_id != null ? (length(var.ami_id) > 4 && substr(var.ami_id, 0, 4) == "ami-") : true
    error_message = "Must be a valid AMI ID starting with 'ami-'."
  }
}

variable "architecture" {
  description = "CPU architecture for Talos AMI lookup. Must match the instance family (t4g/r6g/c6g/m6g/... → arm64; t3/r6i/c6i/m6i/... → amd64)."
  type        = string
  default     = "arm64"

  validation {
    condition     = contains(["amd64", "arm64"], var.architecture)
    error_message = "architecture must be amd64 or arm64."
  }
}

variable "extra_security_group_ids" {
  description = "Additional security group IDs to attach to all cluster nodes"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "service_account_issuer" {
  description = "OIDC issuer URL for Kubernetes service account tokens (e.g. https://oidc-humboldt.cloudhaven.work). Required for IRSA."
  type        = string
  default     = ""
}
