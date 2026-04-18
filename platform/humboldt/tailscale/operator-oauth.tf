resource "tailscale_oauth_client" "humboldt_operator" {
  description = "Tailscale Kubernetes operator - humboldt cluster"
  scopes      = ["devices"]
  tags        = ["tag:k8s-humboldt"]
}

resource "aws_ssm_parameter" "operator_client_id" {
  name        = "/restricted/tailscale/operator/client-id"
  description = "Tailscale OAuth client ID for the humboldt Kubernetes operator"
  type        = "String"
  value       = tailscale_oauth_client.humboldt_operator.id
}

resource "aws_ssm_parameter" "operator_client_secret" {
  name        = "/restricted/tailscale/operator/client-secret"
  description = "Tailscale OAuth client secret for the humboldt Kubernetes operator"
  type        = "SecureString"
  value       = tailscale_oauth_client.humboldt_operator.key

  lifecycle {
    ignore_changes = [value]
  }
}
