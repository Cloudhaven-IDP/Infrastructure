data "aws_availability_zones" "available" {
  state = "available"
}

#------------------------------------------------------------------------------
# AMI — latest official Talos from Sidero Labs (owner: 540036508848)
#------------------------------------------------------------------------------

data "aws_ami" "talos" {
  count = var.ami_id == null ? 1 : 0

  owners      = ["540036508848"]
  most_recent = true
  name_regex  = "^talos-v\\d+\\.\\d+\\.\\d+-${data.aws_availability_zones.available.id}-${var.architecture}$"
}

locals {
  ami_id = var.ami_id != null ? var.ami_id : data.aws_ami.talos[0].id

  tags = merge({
    Name        = var.cluster_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)

  cluster_required_tags = {
    "KubernetesCluster" = var.cluster_name
  }

  # Talos cluster endpoint — NLB DNS if enabled, otherwise first CP node private IP
  cluster_endpoint = var.enable_nlb ? "https://${aws_lb.kubernetes_api[0].dns_name}" : "https://${module.control_plane[0].private_ip}:6443"

  # Patch: register kubelets with FQDN (required for AWS)
  common_machine_config_patch = yamlencode({
    machine = {
      kubelet = {
        registerWithFQDN = true
      }
    }
  })

  # Patch: OIDC service account issuer — required for IRSA
  oidc_patch = var.service_account_issuer != "" ? yamlencode({
    cluster = {
      apiServer = {
        extraArgs = {
          service-account-issuer   = var.service_account_issuer
          service-account-jwks-uri = "${var.service_account_issuer}/openid/v1/jwks"
          anonymous-auth           = "true"
        }
      }
    }
  }) : null

  all_config_patches = concat(
    var.config_patches,
    [local.common_machine_config_patch],
    local.oidc_patch != null ? [local.oidc_patch] : [],
  )
}
