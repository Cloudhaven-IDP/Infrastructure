module "external-secrets-role" {
  source = "../../../../../modules/aws/iam/role"

  role_name = "cloudhaven-agent-role"

  description        = "IAM role for Cloudhaven Agent to access AWS Secrets Manager"
  assume_role_policy = data.aws_iam_policy_document.cloudhaven-agent-role.json

}
