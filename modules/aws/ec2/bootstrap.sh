#!/bin/bash
set -euxo pipefail

# K3S_KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
# NODE_NAME="${1:-k3s-node}"

# # Update system
# yum update -y
# yum upgrade -y

# Install dependencies
# sudo snap install -y \
#   curl \
#   unzip \
#   git \
#   software-properties-common \
#   bash-completion \
#   gnupg \
#   lsb-release \
#   ca-certificates \
#   snapd \
#   awscli \
#   jq \



# # Install Docker (official repo)
# yum install -y docker.io
# systemctl enable docker
# systemctl start docker
# usermod -aG docker ubuntu


# yum update -y
# yum install -y docker-ce docker-ce-cli containerd.io

# usermod -aG docker ubuntu
# systemctl enable docker
# systemctl start docker

# # Install K3s
# curl -sfL https://get.k3s.io | sh -

# # Set up kubeconfig for all users
# echo "export KUBECONFIG=${K3S_KUBECONFIG}" | tee /etc/profile.d/k3s.sh
# chmod +r "${K3S_KUBECONFIG}"

# # Install nerdctl
# NERDCTL_VERSION="1.7.2"
# curl -sSL "https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz" \
#   | tar -xz -C /usr/local/bin

# # Install SSM Agent (via snap)
# snap install amazon-ssm-agent --classic
# systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
# systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

# echo "✅ Bootstrap complete for Ubuntu K3s node: $NODE_NAME"
