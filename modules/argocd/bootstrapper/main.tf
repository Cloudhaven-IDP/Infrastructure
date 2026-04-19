data "aws_ssm_parameter" "cluster_token" {
  for_each        = var.clusters
  name            = "/restricted/argocd/${each.key}/token"
  with_decryption = true
}

resource "argocd_cluster" "this" {
  for_each = var.clusters

  server = each.value.server
  name   = each.key

  config {
    bearer_token = data.aws_ssm_parameter.cluster_token[each.key].value
    tls_client_config {
      ca_data  = each.value.ca_data
      insecure = false
    }
  }
}
