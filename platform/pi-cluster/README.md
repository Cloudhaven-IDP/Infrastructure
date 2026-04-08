# ⚠️ DEPRECATED — pi-cluster

This directory is deprecated and will be removed once the nebulosa cluster migration is complete.

## Replaced By

| What | Old (here) | New |
|---|---|---|
| Home RPi cluster | `afo-pi-cluster` (k3s) | `nebulosa` (k3s on Ubuntu) — `platform/nebulosa/` |
| Network access | Twingate + Cloudflare tunnel | Tailscale WireGuard mesh |
| Cluster networking | Cloudflare DNS/tunnel | Tailscale (`nebulosa-humboldt.ts.net`) |
| GitOps control plane | ArgoCD on RPi | ArgoCD on `humboldt` (AWS), manages both clusters |

## Status

- `twingate/` — do not apply, being replaced by Tailscale
- `cloudflare/` — do not apply, pi-tunnel replaced by Tailscale
- `operators/` — will be re-applied under `platform/nebulosa/` once cluster is up
- `aws/` — IAM roles and secrets still valid, will migrate to `platform/nebulosa/aws/`

## Do Not Apply

Running `terraform apply` in any subdirectory here may provision resources that conflict with the new setup.
