module "langfuse_secret" {
  source      = "../../../modules/aws/secrets-manager"
  name        = "nebulosa/langfuse"
  description = "Langfuse stack secrets"
}
