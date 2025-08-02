#!/bin/bash
set -euo pipefail

K3S_KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
NODE_NAME="${1:-k3s-node}"  # Optional hostname

# Update system
apt-get update -y
apt-get upgrade -y

# Install dependencies
apt-get install -y \
  curl \
  unzip \
  git \
  software-properties-common \
  bash-completion \
  gnupg \
  lsb-release \
  ca-certificates

# Install AWS CLI v2
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# Install Docker (via Docker's official repo)
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker

# Install K3s
curl -sfL https://get.k3s.io | sh -

# Set up kubeconfig for all users
echo "export KUBECONFIG=${K3S_KUBECONFIG}" | tee /etc/profile.d/k3s.sh
chmod +r "${K3S_KUBECONFIG}"

# Install nerdctl
NERDCTL_VERSION="1.7.2"
curl -sSL "https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz" \
  | tar -xz -C /usr/local/bin

# Install SSM Agent
snap install amazon-ssm-agent --classic
systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

# Set hostname
hostnamectl set-hostname "$NODE_NAME"

echo "✅ Ubuntu K3s node '$NODE_NAME' bootstrap complete."
