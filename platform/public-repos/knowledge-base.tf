module "repo_knowledge_base" {
  source         = "../../modules/github/repo/"
  name           = "knowledge-base"
  visibility     = "public"
  description    = "Cloudhaven knowledge base — how-tos, runbooks, and architectural notes rendered to docs.cloudhaven.work"
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
