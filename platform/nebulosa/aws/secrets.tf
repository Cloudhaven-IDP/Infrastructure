module "langfuse_secret" {
  source      = "../../../modules/aws/secrets-manager"
  name        = "nebulosa/langfuse"
  description = "Langfuse stack secrets"
}

module "nebulosa_kubeconfig" {
  source      = "../../../modules/aws/secrets-manager"
  name        = "nebulosa/kubeconfig"
  description = "Full kubeconfig YAML for the nebulosa cluster (admin@nebulosa context). Value managed by scripts/aws/migrate-kubeconfigs-to-secrets-manager.sh."
}
