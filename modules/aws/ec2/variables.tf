#------------------------------------------------------------------------------
# Required
#------------------------------------------------------------------------------

variable "name" {
  description = "Instance name"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}

variable "ami_id" {
  description = "AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (e.g. t4g.nano, t4g.medium)"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID — used to create the instance security group"
  type        = string
}

#------------------------------------------------------------------------------
# Security group rules
#------------------------------------------------------------------------------

variable "ingress_rules" {
  description = "Ingress rules for the instance security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
  }))
  default = []
}

variable "egress_rules" {
  description = "Egress rules for the instance security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
  }))
  default = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "extra_security_group_ids" {
  description = "Additional security group IDs to attach alongside the managed one"
  type        = list(string)
  default     = []
}

#------------------------------------------------------------------------------
# IAM
#------------------------------------------------------------------------------

variable "policy_arns" {
  description = "Policy ARNs to attach to the instance IAM role. Creates a role + instance profile automatically."
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policy name → JSON document to attach to the instance IAM role."
  type        = map(string)
  default     = {}
}

variable "iam_instance_profile" {
  description = "Bring your own instance profile name. Ignored if policy_arns or inline_policies is set."
  type        = string
  default     = null
}

#------------------------------------------------------------------------------
# Optional
#------------------------------------------------------------------------------

variable "user_data" {
  description = "User data script to run on launch"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Associate a public IP address (set false for private subnet nodes)"
  type        = bool
  default     = false
}

variable "source_dest_check" {
  description = "Enable source/dest check. Set false for subnet routers (Tailscale, NAT)"
  type        = bool
  default     = true
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Encrypt the root EBS volume"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "SSH key pair name. Not needed for Talos nodes."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
