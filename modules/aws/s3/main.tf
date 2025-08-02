module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket = var.bucket_name

  force_destroy = true
  attach_policy = true
  policy        = data.aws_iam_policy_document.combined.json

  versioning = {
    status     = var.bucket_versioning_status
    mfa_delete = false
  }

  block_public_acls       = var.block_public_acl
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.block_public_acl
  restrict_public_buckets = var.restrict_public_buckets

  attach_elb_log_delivery_policy        = true
  attach_lb_log_delivery_policy         = true
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  lifecycle_rule = var.lifecycle_rule
  transition_default_minimum_object_size = var.transition_default_minimum_object_size
  intelligent_tiering                    = var.intelligent_tiering

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = false
    }
  }

  tags = merge({
    Name = var.bucket_name
  }, var.tags)
}
