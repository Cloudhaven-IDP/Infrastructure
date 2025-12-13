data "twingate_remote_network" "this" {
  count = var.twingate_network_name != null ? 1 : 0
  name  = var.twingate_network_name
}

locals {
  release_name = var.release_name == null ? var.connector_name : var.release_name
}