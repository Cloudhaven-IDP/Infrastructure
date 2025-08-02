module "teams" {
  source = "../../../../modules/github/team/"

  teams = [
    {
      name        = "cloudhaven-devops"
      description = "DevOps team for managing infrastructure"
      privacy     = "closed"
    }
  ]
}
