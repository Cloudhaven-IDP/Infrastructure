module "repo_infrastructure" {
  source         = "../../../../modules/github/repo/"
  name           = "Infrastructure"
  description    = "Infrastructure as code repo"
  default_branch = "main"

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


