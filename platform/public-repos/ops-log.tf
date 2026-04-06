module "repo_ops_log" {
  source         = "../../modules/github/repo/"
  name           = "ops-log"
  visibility     = "public"
  description    = "Engineering devlog — daily work diary, decisions, and project TODO"
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
