locals {
  oidc_url = var.cluster != null ? "oidc-${var.cluster}.${var.domain}" : var.oidc_provider_url
}

module "role" {
  source = "../role"

  role_name          = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
  policy_arns        = var.policy_arns
  inline_policies    = var.inline_policy_json != null ? { (var.role_name) = var.inline_policy_json } : {}
  tags               = var.tags
}
