module "repo_actions" {
  source           = "../../../../modules/github/repo/"
  name             = "Actions"
  description      = "Reusable GitHub Actions repository"
  default_branch   = "main"

  teams = [
  {
    id         = data.github_team.cloudhaven_devops.slug
    permission = "admin"
    } 
  ] 

  reviewer_teams = [
    { name = data.github_team.cloudhaven_devops.slug }
  ]
}