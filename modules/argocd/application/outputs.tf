output "app_name" {
  value = argocd_application.this.metadata[0].name
}
