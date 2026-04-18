module "talos" {
  source = "../../../modules/talos"

  cluster_name = local.config.cluster
  environment  = local.config.environment

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Single control plane for now — scale to 3 when HA is needed
  control_plane_instance_type = "t3.small"
  control_plane_count         = 1

  # Workers — t3.medium, KEDA-managed via cluster autoscaler
  worker_instance_type = "t3.medium"
  worker_min           = 1
  worker_max           = 5
  worker_desired       = 2

  # Private subnet — nodes reached via Tailscale subnet router (10.0.0.0/16)
  associate_public_ip = false

  # Tailscale CIDR + VPC CIDR — subnet router SNATs traffic so source IP is a VPC IP
  talos_api_allowed_cidrs     = ["100.64.0.0/10", "10.0.0.0/16"]
  kubernetes_api_allowed_cidrs = ["100.64.0.0/10", "10.0.0.0/16"]

  # NLB off — API is internal, reached via Tailscale
  enable_nlb = false

  tags = {
    Cluster = local.config.cluster
  }
}
