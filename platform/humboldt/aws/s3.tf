module "etcd_snapshots_bucket" {
  source = "../../../modules/aws/s3"

  bucket_name = "${local.config.cluster}-talos-etcd-snapshot"
  description = "Talos etcd snapshots for ${local.config.cluster}"

  versioning_enabled       = true
  enforce_secure_transport = true

  lifecycle_rules = [{
    id     = "expire-snapshots"
    status = "Enabled"
    transition = {
      days          = 30
      storage_class = "GLACIER_IR"
    }
    expiration = {
      days = 180
    }
    noncurrent_version_expiration = {
      noncurrent_days = 30
    }
  }]
}
