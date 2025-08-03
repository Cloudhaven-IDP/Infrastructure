module "cloudhaven_admin_access" {
  source = "../modules/identitycenter/permission_set"

  permission_set_name   = "Cloudhaven-Admin"
  description           = "Admin access for Cloudhaven platform"
  session_duration      = "PT4H"
  access_restricted_ssm = true

  group_names = [
    "Cloudhaven-Admins"
  ]

  group_memberships = jsondecode(file("${path.module}/group_memberships.json"))

  account_ids = [data.aws_caller_identity.current.account_id]

  aws_managed_policies = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]

}

####

#to be used with authentik

###
# module "okta_ews_groups" {
#   source = "../../../modules/okta/group-membership/v2"

#   for_each = fileset(path.module, "ews-*.yaml")

#   user_groups = yamldecode(file(each.value))["groups"]
#   track_all_users = false
# }