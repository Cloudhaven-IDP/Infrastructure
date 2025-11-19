module "repo_k8s_bootstrap" {
  source         = "../../modules/github/repo/"
  name           = "K8s-Bootstrap"
  visibility     = "public"
  description    = "Bootstrap repository for Kubernetes clusters"
  default_branch = "main"
  bypass_actors = [
    {
      actor_type = "OrganizationAdmin"
    }
  ]

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
