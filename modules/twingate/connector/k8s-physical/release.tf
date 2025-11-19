data "twingate_remote_network" "this" {
  name = var.twingate_network
}

resource "twingate_connector" "this" {
  remote_network_id = data.twingate_remote_network.this.id
  name              = var.connector_name
}

resource "twingate_connector_tokens" "this" {
  connector_id = twingate_connector.this.id
}

resource "helm_release" "twingate-connector" {
  name             = "twingate-connector"
  repository       = "https://twingate.github.io/helm-charts"
  chart            = "connector"
  namespace        = "twingate-connector"
  create_namespace = true

  set = [
    {
      name  = "twingate.network"
      value = data.twingate_remote_network.this.id
    },
    {
      name  = "twingate.accessToken"
      value = twingate_connector_tokens.this.access_token
    },
    {
      name  = "twingate.refreshToken"
      value = twingate_connector_tokens.this.refresh_token
    },
    {
      name  = "twingate.connectorName"
      value = var.connector_name
    }
  ]

  values = var.values_file != null ? [file(var.values_file)] : []

  depends_on = [
    twingate_connector_tokens.this
  ]
}
