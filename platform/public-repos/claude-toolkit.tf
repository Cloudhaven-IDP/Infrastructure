module "repo_claude_toolkit" {
  source         = "../../modules/github/repo/"
  name           = "claude-toolkit"
  visibility     = "public"
  description    = "Claude Code skills and agents — reusable prompts, reference docs, and automation tools"
  default_branch = "main"

  bypass_actors = [
    {
      actor_type = "OrganizationAdmin"
    }
  ]

  teams = [
    {
      id         = data.github_team.cloudhaven_devops.id
      permission = "admin"
    }
  ]

  reviewer_teams = [
    { name = data.github_team.cloudhaven_devops.slug }
  ]
}
