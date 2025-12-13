module "twingate-connector" {
  source                = "../../../modules/twingate/connector/k8s-physical"
  connector_name        = "pi-cluster-connector"
  release_name          = "twingate-pi-cluster-connector" #redundant but importing isnt easy :)
  twingate_network_name = twingate_remote_network.home_network.name
  twingate_account      = local.config.account
  helm_values           = "${path.module}/configurations/values.yaml"
  secret_name           = "twingate-pi-cluster-connector"
}
