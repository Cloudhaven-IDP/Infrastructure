# Infrastructure
Infrastructure as code repo

Cloudhaven Infrastructure
Cloudhaven is a GitOps-driven, cloud-native access management platform built for cost efficiency, flexibility, and transparency. We're combining ECS (for frontend microservices like request and approval portals) with a fully serverless backend stack leveraging EventBridge, Lambda, and DynamoDB.

Supporting services—such as Authentik (SSO), Atlantis (IaC automation), Grafana, VictoriaMetrics, and HyperDX—are self-hosted on a lightweight k3s Kubernetes cluster running on EC2 bare metal. APISIX acts as our ingress gateway, replacing traditional API Gateway while allowing internal and external routing.

Infrastructure is provisioned and managed via Terraform, with modularity and reuse as key principles. Atlantis provides automated Terraform workflow handling, and Chamber + AWS SSM Parameter Store are used for secrets management.

This stack is intentionally minimal, secure, and highly auditable—designed to scale with open source tooling and a strong DevOps foundation.

