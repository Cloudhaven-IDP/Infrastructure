module "repo_theo" {
  source         = "../../../modules/github/repo/"
  name           = "theo"
  visibility     = "private"
  description    = "Theo — AI health agent backend. Agents, workers, API, and LangChain orchestration."
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
