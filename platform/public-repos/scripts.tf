module "repo_scripts" {
  source         = "../../modules/github/repo/"
  name           = "scripts"
  visibility     = "public"
  description    = "Operational scripts — k3s config, AWS bootstrapping, Cloudflare setup. Used by CI/CD pipelines."
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
