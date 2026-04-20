module "repo_theo_agents" {
  source         = "../../modules/github/repo/"
  name           = "theo-agents"
  visibility     = "public"
  description    = "Theo agents monorepo — path-filtered CI deploys only affected agents."
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
