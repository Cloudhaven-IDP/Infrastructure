import {
  id = "twingate-connector/twingate-pi-cluster-connector"
  to = module.twingate-connector.helm_release.twingate-connector
}

import {
  id = "twingate-connector/twingate-pi-cluster-connector"
  to = module.twingate-connector.kubernetes_secret_v1.twingate-connector-secret
}

import {
  id = "Q29ubmVjdG9yOjY2MTY0Mg=="
  to = module.twingate-connector.twingate_connector.this
}