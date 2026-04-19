data "aws_ssm_parameter" "cloudflare_api_token" {
  name            = "/restricted/cloudflare/api-token"
  with_decryption = true
}

data "aws_ssm_parameter" "cloudflare_account_id" {
  name            = "/cloudflare/account-id"
  with_decryption = true
}

data "aws_ssm_parameters_by_path" "nebulosa_kubeconfig" {
  path            = "/restricted/nebulosa/kubeconfig"
  with_decryption = true
}

locals {
  kube = zipmap(
    [for name in data.aws_ssm_parameters_by_path.nebulosa_kubeconfig.names : basename(name)],
    data.aws_ssm_parameters_by_path.nebulosa_kubeconfig.values
  )
}
