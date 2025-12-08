data "aws_ssm_parameter" "cloudflare_api_token" {
  name = "/cloudflare/api-token"
}

data "aws_secretsmanager_secret_version" "kube_api" {
  secret_id = "kube-api-info"
}