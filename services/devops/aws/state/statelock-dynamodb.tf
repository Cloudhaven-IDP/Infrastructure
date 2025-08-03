module "dynamodb_state_lock" {
  source = "../../../../modules/aws/dynamodb"

  name    = "tf-state-lock"
  service = local.config.Service
  attributes = [
    { name = "LockID", type = "S" }
  ]
  billing_mode                   = "PROVISIONED"
  read_capacity                  = 5
  write_capacity                 = 5
  ttl_enabled                    = false
  point_in_time_recovery_enabled = false
  deletion_protection_enabled    = true

  generate_access_policies = false

}