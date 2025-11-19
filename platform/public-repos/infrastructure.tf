module "repo_infrastructure" {
  source         = "../../modules/github/repo/"
  name           = "Infrastructure"
  visibility     = "public"
  description    = "Infrastructure as code repo"
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
