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
