module "repo_frontend" {
  source         = "../../../../modules/github/repo/"
  name           = "clouhaven-frontend"
  description    = "Cloudhaven Frontend repository"
  default_branch = "main"

  teams = [
    {
      id         = "cloudhaven-devops"
      permission = "admin"
    }
  ]

  reviewer_teams = [
    { name = "cloudhaven-devops" }
  ]
}