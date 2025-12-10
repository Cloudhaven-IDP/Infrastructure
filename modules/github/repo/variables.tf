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
  default     = []
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

variable "bypass_actors" {
  type = list(object({
    actor_id   = optional(number, null)
    actor_type = string
  }))
  default     = []
  description = "List of actors (users, teams, or integrations) that can bypass the ruleset. actor_type can be: OrganizationAdmin, RepositoryRole, Team, Integration, or RepositoryAdmin. actor_id is optional and not needed for OrganizationAdmin or RepositoryRole"
}

variable "has_issues" {
  type        = bool
  default     = true
  description = "Set to true to enable the GitHub Issues features on the repository"
}

variable "has_downloads" {
  type        = bool
  default     = true
  description = "Set to true to enable the GitHub Downloads features on the repository"
}

variable "has_wiki" {
  type        = bool
  default     = false
  description = "Set to true to enable the GitHub Wiki features on the repository"
}

variable "has_projects" {
  type        = bool
  default     = false
  description = "Set to true to enable the GitHub Projects features on the repository"
}
