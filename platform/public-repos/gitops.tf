module "repo_gitops" {
  source         = "../../modules/github/repo/"
  name           = "GitOps"
  visibility     = "public"
  description    = "GitOps repo"
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
