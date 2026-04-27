# syntax=docker/dockerfile:1.7

ARG RUNNER_VERSION=2.321.0
FROM ghcr.io/actions/actions-runner:${RUNNER_VERSION}

ARG TARGETARCH
ARG KUBECTL_VERSION=v1.32.0
ARG KUSTOMIZE_VERSION=v5.5.0
ARG HELM_VERSION=v3.16.3
ARG ARGOCD_VERSION=v2.13.1
ARG TALOSCTL_VERSION=v1.9.1
ARG TAILSCALE_VERSION=1.78.1
ARG YQ_VERSION=v4.44.5

USER root

RUN <<'BASH'
set -eux
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg lsb-release \
    jq make git unzip xz-utils
rm -rf /var/lib/apt/lists/*

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gh
rm -rf /var/lib/apt/lists/*
BASH

RUN <<BASH
set -eux

curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" -o /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl

curl -fsSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_${TARGETARCH}.tar.gz" \
    | tar -xz -C /usr/local/bin

curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" -o /tmp/helm.tgz
tar -xzf /tmp/helm.tgz -C /tmp
mv "/tmp/linux-${TARGETARCH}/helm" /usr/local/bin/helm
rm -rf /tmp/helm.tgz "/tmp/linux-${TARGETARCH}"

curl -fsSL "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-${TARGETARCH}" -o /usr/local/bin/argocd
chmod +x /usr/local/bin/argocd

curl -fsSL "https://github.com/siderolabs/talos/releases/download/${TALOSCTL_VERSION}/talosctl-linux-${TARGETARCH}" -o /usr/local/bin/talosctl
chmod +x /usr/local/bin/talosctl

curl -fsSL "https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE_VERSION}_${TARGETARCH}.tgz" -o /tmp/tailscale.tgz
tar -xzf /tmp/tailscale.tgz -C /tmp
mv "/tmp/tailscale_${TAILSCALE_VERSION}_${TARGETARCH}/tailscale" /usr/local/bin/tailscale
chmod +x /usr/local/bin/tailscale
rm -rf /tmp/tailscale.tgz "/tmp/tailscale_${TAILSCALE_VERSION}_${TARGETARCH}"

curl -fsSL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${TARGETARCH}" -o /usr/local/bin/yq
chmod +x /usr/local/bin/yq

case "${TARGETARCH}" in
  amd64) AWSCLI_ARCH=x86_64 ;;
  arm64) AWSCLI_ARCH=aarch64 ;;
esac
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}.zip" -o /tmp/awscliv2.zip
unzip -q /tmp/awscliv2.zip -d /tmp
/tmp/aws/install
rm -rf /tmp/awscliv2.zip /tmp/aws
BASH

USER runner
