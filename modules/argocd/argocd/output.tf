output "namespace" {
  description = "The namespace where ArgoCD is deployed"
  value       = helm_release.argocd.namespace

}

output "release_name" {
  description = "The name of the ArgoCD Helm release"
  value       = helm_release.argocd.name
}