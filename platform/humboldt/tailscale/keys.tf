#------------------------------------------------------------------------------
# Auth key for the humboldt subnet router
# Stored in SSM so the EC2 instance can fetch it at boot without Terraform coupling
#------------------------------------------------------------------------------

resource "tailscale_tailnet_key" "subnet_router" {
  reusable      = false
  ephemeral     = false
  preauthorized = true
  expiry        = 7776000 # 90 days
  description   = "humboldt subnet router"

  tags = ["tag:subnet-router"]

  depends_on = [tailscale_acl.this]
}

resource "aws_ssm_parameter" "tailscale_auth_key" {
  name        = "/restricted/tailscale/auth-key"
  description = "Tailscale auth key for humboldt subnet router"
  type        = "SecureString"
  value       = tailscale_tailnet_key.subnet_router.key

  lifecycle {
    ignore_changes = [value]
  }
}
