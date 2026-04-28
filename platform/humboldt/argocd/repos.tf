locals {
  repos = {
    "K8s-Bootstrap" = "git@github.com:Cloudhaven-IDP/K8s-Bootstrap.git"
    "gitops"        = "git@github.com:Cloudhaven-IDP/gitops.git"
  }
}

data "aws_ssm_parameter" "deploy_keys" {
  for_each        = local.repos
  name            = "/restricted/github/deploy-keys/${lower(each.key)}"
  with_decryption = true
}

resource "argocd_repository" "this" {
  for_each = local.repos

  repo            = each.value
  ssh_private_key = data.aws_ssm_parameter.deploy_keys[each.key].value
}
