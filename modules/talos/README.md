# Talos Cluster Module

Creates a Talos Linux Kubernetes cluster on AWS EC2, following the
[Siderolabs AWS guide](https://docs.siderolabs.com/talos/v1.12/platform-specific-installations/cloud-platforms/aws).

## What it creates

- Control plane EC2 instances via `modules/aws/ec2` (individual — Talos config apply needs stable IPs)
- Worker ASG with launch template (machine config as userdata, cluster autoscaler compatible)
- Security groups (intra-cluster + K8s API, configurable additional rules)
- NLB for Kubernetes API (optional — disabled by default, use Cloudflare Tunnel or Tailscale)
- Talos machine secrets, configs, bootstrap, kubeconfig, and health check
- Kubeconfig stored in Secrets Manager for cross-state consumption

## Usage

```hcl
module "talos" {
  source = "../../../modules/talos"

  cluster_name = "humboldt"
  environment  = "prod"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnets

  control_plane_instance_type = "t3.medium"
  control_plane_count         = 1

  worker_instance_type = "t3.large"
  worker_min           = 1
  worker_max           = 5
  worker_desired       = 2

  # Restrict API access to Tailscale CIDR
  talos_api_allowed_cidr      = "100.64.0.0/10"
  kubernetes_api_allowed_cidr = "100.64.0.0/10"
}
```

### Consuming kubeconfig from another state

```hcl
data "aws_secretsmanager_secret_version" "kube_api" {
  secret_id = "humboldt/kubeconfig"
}

locals {
  kube = jsondecode(data.aws_secretsmanager_secret_version.kube_api.secret_string)
}

provider "kubernetes" {
  host                   = local.kube.host
  client_certificate     = base64decode(local.kube.client_certificate_data)
  client_key             = base64decode(local.kube.client_key_data)
  cluster_ca_certificate = base64decode(local.kube.cluster_ca_certificate_data)
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Cluster name | string | - | yes |
| environment | Environment | string | - | yes |
| vpc_id | VPC ID | string | - | yes |
| subnet_ids | Subnet IDs | list(string) | - | yes |
| control_plane_instance_type | CP instance type | string | t3.medium | no |
| control_plane_count | CP nodes (odd) | number | 1 | no |
| control_plane_volume_size | CP root volume GB | number | 50 | no |
| worker_instance_type | Worker instance type | string | t3.large | no |
| worker_min | ASG min workers | number | 1 | no |
| worker_max | ASG max workers | number | 5 | no |
| worker_desired | ASG desired workers | number | 2 | no |
| worker_volume_size | Worker root volume GB | number | 100 | no |
| enable_nlb | Create NLB for K8s API | bool | false | no |
| talos_api_allowed_cidr | CIDR for Talos API | string | 0.0.0.0/0 | no |
| kubernetes_api_allowed_cidr | CIDR for K8s API | string | 0.0.0.0/0 | no |
| additional_api_ingress_rules | Extra K8s API SG rules | list(object) | [] | no |
| config_patches | Patches for all nodes | list(string) | [] | no |
| control_plane_config_patches | CP-only patches | list(string) | [] | no |
| worker_config_patches | Worker-only patches | list(string) | [] | no |
| ami_id | Override Talos AMI | string | null | no |
| extra_security_group_ids | Additional SG IDs | list(string) | [] | no |
| tags | Additional tags | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| kubeconfig | Raw kubeconfig YAML (sensitive) |
| talosconfig | Talosctl config (sensitive) |
| cluster_endpoint | K8s API endpoint URL |
| kubeconfig_secret_arn | Secrets Manager ARN for cross-state use |
| control_plane_ips | CP private IPs |
| worker_asg_name | Worker ASG name (for cluster autoscaler) |
| cluster_security_group_id | Intra-cluster SG ID |
| kubernetes_api_security_group_id | K8s API SG ID |
