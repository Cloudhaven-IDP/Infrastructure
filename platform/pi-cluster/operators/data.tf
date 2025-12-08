data "aws_secretsmanager_secret_version" "kube_api" {
  secret_id = "kube-api-info"
}