
variable "teams" {
  description = "List of GitHub teams to create"
  type = list(object({
    name        = string
    description = optional(string, "")
    privacy     = optional(string, "closed") # open | closed
    parent_team_id = optional(string)
  }))
}
