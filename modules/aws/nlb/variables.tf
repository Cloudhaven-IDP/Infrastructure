variable "name" {
  description = "Name prefix for the NLB and related resources"
  type        = string
}

variable "type" {
  description = "Type of the NLB (e.g., 'network')"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to deploy the NLB into"
  type        = list(string)
}

variable "internal" {
  description = "Whether the NLB is internal"
  type        = bool
  default     = false
}

variable "target_instance_id" {
  description = "Instance ID to target with the NLB"
  type        = string
}

variable "port" {
  description = "Listener port for the NLB"
  type        = number
  default     = 80
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "create_eips" {
  description = "Whether to create Elastic IPs for the NLB"
  type        = bool
  default     = true
  
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing for the NLB"
  type        = bool
  default     = true
  
}