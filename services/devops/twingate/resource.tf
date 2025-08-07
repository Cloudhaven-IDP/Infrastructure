resource "twingate_remote_network" "aws" {
  name = "aws_remote_network"

}

resource "twingate_resource" "this" {
  for_each = { for r in local.twingate_resources : r.name => r }

  name              = each.value.name
  address           = each.value.address
  remote_network_id = twingate_remote_network.aws.id
}

