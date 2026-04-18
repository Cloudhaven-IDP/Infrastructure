#------------------------------------------------------------------------------
# Tailscale ACL — source of truth for the entire tailnet policy.
#------------------------------------------------------------------------------

resource "tailscale_acl" "this" {
  acl = jsonencode({
    tagOwners = {
      "tag:k8s-cp"        = ["autogroup:admin"]
      "tag:k8s-worker"    = ["autogroup:admin"]
      "tag:subnet-router" = ["autogroup:admin"]
      "tag:k8s-humboldt"  = ["autogroup:admin"]
    }

    acls = [
      # Admins can reach everything — including both API servers on 6443
      {
        action = "accept"
        src    = ["autogroup:admin"]
        dst    = ["*:*"]
      },
      # Control planes talk to each other (ArgoCD on humboldt → nebulosa API, etc.)
      {
        action = "accept"
        src    = ["tag:k8s-cp"]
        dst    = ["tag:k8s-cp:*"]
      },
      # Control planes manage their workers
      {
        action = "accept"
        src    = ["tag:k8s-cp"]
        dst    = ["tag:k8s-worker:*"]
      },
      # Workers register back to control plane
      {
        action = "accept"
        src    = ["tag:k8s-worker"]
        dst    = ["tag:k8s-cp:*"]
      },
      # Pod-to-pod across both clusters
      {
        action = "accept"
        src    = ["tag:k8s-worker"]
        dst    = ["tag:k8s-worker:*"]
      }
    ]

    autoApprovers = {
      routes = {
        "10.0.0.0/16" = ["tag:subnet-router"]
      }
    }
  })
}
