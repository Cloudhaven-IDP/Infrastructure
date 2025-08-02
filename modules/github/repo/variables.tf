variable "name" {
  description = "The name of the GitHub repository"
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "Repository name cannot be empty."
  }
}

variable "description" {
  type        = string
  default     = ""
  description = "A short description of the repository"
}

variable "visibility" {
  type        = string
  default     = "public"
  description = "Visibility of the repository (public/private)"
}

variable "default_branch" {
  type        = string
  default     = "main"
  description = "The default branch of the repository"
}

variable "create_codeowners" {
  type        = bool
  default     = true
  description = "Whether to create a CODEOWNERS file"
}

variable "reviewer_teams" {
  type = list(object({
    name = string
  }))
  description = "List of teams to be added as code owners"
}

variable "teams" {
  type = list(object({
    id         = string
    permission = any
  }))
  description = "List of team ids and their permissions"
  default     = []
}

variable "codeowners_vars" {
  type        = map(string)
  default     = {}
  description = "Variables to pass into the CODEOWNERS template"
}
