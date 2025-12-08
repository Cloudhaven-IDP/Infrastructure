# Infrastructure as Code

This repository contains Terraform configurations for managing Cloudhaven's platform resources. It follows a modular structure to promote reusability and maintainability.

## 📁 Repository Structure

```
Infrastructure/
├── modules/           # Reusable Terraform modules
├── applications/     # Application-specific infrastructure
├── platform/         # Platform-level resources
└── README.md
```

## 🧩 Modules (`modules/`)

Reusable Terraform modules for common resources. These modules can be called from applications or platform configurations.

## 📦 Applications (`applications/`)

Application-specific infrastructure resources. Each application directory contains AWS resources needed for that application (ECR repositories, IAM roles, secrets, etc.).

### Current Applications

- **`cloudhaven-agent/`**

## 🏗️ Platform (`platform/`)

Platform-level resources that are not specific to individual applications. These include public repositories, cluster infrastructure, and shared services.

### Public Repositories (`platform/public-repos/`)

Manages GitHub repositories for platform-level projects:

- **Infrastructure** - This repository
- **GitOps** - GitOps repository for application deployments
- **K8s-Bootstrap** - Kubernetes cluster bootstrap configurations (see [K8s-Bootstrap](https://github.com/Cloudhaven-IDP/K8s-Bootstrap/tree/main/afo-pi-cluster))

Each repository is configured with:
- CODEOWNERS file
- Repository rulesets
- Team permissions

### Pi Cluster (`platform/pi-cluster/`)

Infrastructure for the Raspberry Pi Kubernetes cluster (`afo-pi-cluster`). This includes Helm chart deployments for operators and services that would otherwise need to be manually applied.

#### Related Resources

Some resources deployed here relate to configurations in the [K8s-Bootstrap repository](https://github.com/Cloudhaven-IDP/K8s-Bootstrap/tree/main/afo-pi-cluster), which contains:
- Kustomize configurations
- Application deployments
- Cluster-level configurations

## 🚀 Getting Started

### Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- Kubernetes cluster access (for platform/pi-cluster resources)

### Configuration

Each directory contains a `config.yaml` file with environment-specific configuration:

```yaml
network: "home-network"
managedBy: "terraform"
project: "cloudhaven"
region: "us-east-1"
cluster: "afo-pi-cluster"
```

### Usage Examples

#### Deploying Application Resources

```bash
cd applications/cloudhaven-agent/aws/ecr
#add configuration files
terraform init
terraform plan
terraform apply
```

#### Using Modules

```hcl
module "ecr_repo" {
  source = "../../modules/aws/ecr"
  
  repository_name = "my-app"
  image_tag_mutability = "MUTABLE"
}
```

## 🔐 State Management

All Terraform state is stored in AWS S3 with the following bucket:
- **Bucket**: `cloudhaven-tf-bucket-state`
- **Region**: `us-east-1`
- **Encryption**: Enabled
- **Locking**: Enabled via S3 lockfiles

Each directory has its own state file path defined in the `backend` configuration.

## 📝 Best Practices

1. **Module Reusability**: Always check if a module exists before creating new resources
2. **State Isolation**: Each application/platform component has its own state file
3. **Configuration Files**: Use `config.yaml` for environment-specific values
4. **Tagging**: Resources are automatically tagged with project metadata


## 🔗 Related Repositories

- [K8s-Bootstrap](https://github.com/Cloudhaven-IDP/K8s-Bootstrap) - Kubernetes cluster bootstrap and application configurations
- [GitOps](https://github.com/Cloudhaven-IDP/GitOps) - Application deployment manifests

## 🤝 Contributing

Feel free to contribure; When adding new resources:

1. Check if a reusable module exists in `modules/`
2. Create application-specific resources in `applications/`
3. Create platform-level resources in `platform/`
4. Update this README with new resources

