module "repo_cloudhaven_agent" {
  source         = "../../modules/github/repo/"
  name           = "cloudhaven-agent"
  visibility     = "public"
  description    = "Cloudhaven agent repo for cloudhaven-agent service"
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
