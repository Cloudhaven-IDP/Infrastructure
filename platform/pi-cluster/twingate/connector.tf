module "twingate-connector" {
  source = "../../../modules/twingate/k8s-physical"
  connector_name = "pi-cluster-connector"
  twingate_network = twingate_remote_network.home_network.name
  values_file = "${path.module}/values.yaml"
}