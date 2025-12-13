data "twingate_groups" "everyone" {
  name_contains = "Every"
}

resource "twingate_resource" "pi_cluster_resources" {
  for_each = local.resources

  remote_network_id           = twingate_remote_network.home_network.id
  name                        = each.key
  address                     = data.aws_ssm_parameter.address[each.key].value
  alias                       = each.value.alias
  is_browser_shortcut_enabled = try(each.value.is_browser_shortcut_enabled, false)

  protocols = {
    allow_icmp = true
    tcp = {
      policy = try(each.value.port, null) != null ? "RESTRICTED" : "ALLOW_ALL"
      ports  = try(each.value.port, null) != null ? [tostring(each.value.port)] : []
    }
    udp = {
      policy = "ALLOW_ALL"
    }
  }

  access_group {
    group_id = data.twingate_groups.everyone.groups[0].id
  }
}

#movee to own directory to seperate state, https://registry.terraform.io/providers/hashicorp/tfmigrate/latest/docs/resources/state_migration
