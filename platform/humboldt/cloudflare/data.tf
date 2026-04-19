data "aws_secretsmanager_secret_version" "kubeconfig" {
  secret_id = "humboldt/kubeconfig"
}

locals {
  kube = jsondecode(data.aws_secretsmanager_secret_version.kubeconfig.secret_string)
}

data "aws_ssm_parameter" "cloudflare_api_token" {
  name            = "/restricted/cloudflare/api-token"
  with_decryption = true
}

data "aws_ssm_parameter" "cloudflare_account_id" {
  name            = "/cloudflare/account-id"
  with_decryption = true
}

