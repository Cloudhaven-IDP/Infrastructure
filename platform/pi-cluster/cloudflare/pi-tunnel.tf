module "pi-tunnel" {
  source = "../../../modules/cloudflare/tunnel"

  tunnel_name           = "pi-tunnel"
  namespace             = "nginx-ingress"
  cloudflare_account_id = "d43c34b50b545a7e0460dc62b2c48622"
  ingress_rules = [
    {
      service  = "http://nginx-ingress-controller.nginx-ingress.svc.cluster.local:80"
      hostname = "*.cloudhaven.work"
    }
  ]
}