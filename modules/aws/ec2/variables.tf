variable "name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  description = "AMI ID to launch the instance"
  type        = string
}

variable "subnet" {
  description = "List of private subnet IDs to deploy the instance into"
  type        = list(string)
}

variable "iam_role_name" {
  description = "IAM role name to attach to the EC2 instance profile"
  type        = string
  default     = null
}

variable "instance_profile_name" {
  description = "EC2 instance profile name"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "user_data_script" {
  description = "User data script to run on instance launch"
  type        = string
  default     = null

}

variable "key_name" {
  description = "Name of the key pair to use for SSH access"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring for the EC2 instance"
  type        = bool
  default     = true

}

variable "create_sg_rules" {
  description = "Flag to create security group rules"
  type        = bool
  default     = true

}

variable "ports" {
  description = "List of ports for the NLB listeners"
  type        = list(number)
  default     = [80]

}

variable "nlb_security_group_id" {
  description = "Security group ID for the NLB"
  type        = string
  default     = null

}

variable "create_eip" {
  description = "Flag to create an Elastic IP for the EC2 instance"
  type        = bool
  default     = true

}