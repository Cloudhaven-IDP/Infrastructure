module "langfuse_blobs" {
  source = "../../../modules/aws/s3"

  bucket_name = "nebulosa-langfuse-blobs"
  description = "Langfuse blob storage — event traces, large prompts/responses"
}
