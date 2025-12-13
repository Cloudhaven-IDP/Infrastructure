module "gha-deployer" {
  source             = "../../../../../modules/aws/iam/role"
  role_name          = "gha-deployer"
  assume_role_policy = data.aws_iam_policy_document.gha_deployer_assume_role_policy.json
  inline_policies = {
    "gha-deployer-policy" = data.aws_iam_policy_document.gha_deployer_policy.json
    }
  }
