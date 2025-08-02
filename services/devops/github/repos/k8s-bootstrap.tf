module "repo_k8s_bootstrap" {
  source           = "../../../../modules/github/repo/"
  name             = "K8s-Bootstrap"
  description      = "Bootstrap repository for Kubernetes clusters"
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