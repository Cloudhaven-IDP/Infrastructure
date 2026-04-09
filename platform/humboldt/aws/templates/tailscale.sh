#!/bin/bash
set -euo pipefail

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Get auth key from SSM Parameter Store
AUTH_KEY=$(aws ssm get-parameter \
  --name "${parameter_name}" \
  --region "${region}" \
  --with-decryption \
  --query Parameter.Value \
  --output text)

# Enable IP forwarding for subnet routing
echo 'net.ipv4.ip_forward = 1' | tee /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

# Bring up Tailscale
tailscale up \
  --authkey="$AUTH_KEY" \
  --advertise-routes="${advertise_routes}" \
  --accept-dns=false \
  --hostname="${hostname}"
