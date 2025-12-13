locals {
  resources = yamldecode(file("${path.module}/configurations/resources.yaml"))
  config    = yamldecode(file("${path.module}/../config.yaml"))
  kube      = jsondecode(data.aws_secretsmanager_secret_version.kube_api.secret_string)
  default_tags = {
    network   = local.config.network
    managedBy = local.config.managedBy
    account   = local.config.account
    region    = local.config.region
    cluster   = local.config.cluster
  }
}

data "aws_secretsmanager_secret_version" "kube_api" {
  secret_id = "kube-api-info"
}

data "aws_ssm_parameter" "twingate_api_token" {
  name = "/twingate/api-token"
}

data "aws_ssm_parameter" "address" {
  for_each = local.resources
  name     = "/twingate/${each.key}/ip"
}