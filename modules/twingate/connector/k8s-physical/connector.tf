resource "twingate_connector" "this" {
  remote_network_id = data.twingate_remote_network.this[0].id
  name              = var.connector_name
}

resource "twingate_connector_tokens" "this" {
  connector_id = twingate_connector.this.id
}
