module "talos" {
  source = "../../../modules/talos"

  cluster_name = local.config.cluster
  environment  = local.config.environment

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets


  control_plane_instance_type = "t4g.medium"
  control_plane_count         = 1

  worker_instance_type = "r6g.2xlarge"
  worker_min           = 1
  worker_max           = 2
  worker_desired       = 1

  associate_public_ip = false

  config_patches = [
    yamlencode({
      cluster = {
        network = {
          cni = {
            name = "none"
          }
        }
      }
    })
  ]

  # Tailscale CIDR + VPC CIDR — subnet router SNATs traffic so source IP is a VPC IP
  talos_api_allowed_cidrs      = ["100.64.0.0/10", "10.0.0.0/16"]
  kubernetes_api_allowed_cidrs = ["100.64.0.0/10", "10.0.0.0/16"]

  # NLB off — API is internal, reached via Tailscale
  enable_nlb = false

  # OIDC issuer — exposes /.well-known/openid-configuration via Cloudflare tunnel
  service_account_issuer = "https://oidc-humboldt.cloudhaven.work"

  external_cloud_provider = true

  tags = {
    Cluster = local.config.cluster
  }
}
