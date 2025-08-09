# Infrastructure
Infrastructure as code repo

Cloudhaven is a GitOps-driven, cloud-native internal developer platform built for cost efficiency, flexibility, and transparency. We're combining EKS (for frontend microservices like the request and approval portals) with a fully serverless backend stack leveraging Step Functions, Lambda, and DynamoDB.

Supporting services—such as Authentik (SSO), Atlantis (IaC automation), Grafana, VictoriaMetrics, and HyperDX—are self-hosted on an EKS Kubernetes cluster. APISIX acts as our ingress gateway, replacing traditional API Gateway while allowing internal and external routing.

Infrastructure is provisioned and managed via Terraform, with modularity and reuse as key principles. Atlantis provides automated Terraform workflow handling.

This stack is intentionally minimal, secure, and highly auditable—designed to scale with open source tooling and a strong DevOps foundation.

