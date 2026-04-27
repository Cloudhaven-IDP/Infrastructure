data "aws_ssm_parameter" "grafana_admin_user" {
  name            = "/restricted/grafana/admin-user"
  with_decryption = true
}

data "aws_ssm_parameter" "grafana_admin_password" {
  name            = "/restricted/grafana/admin-password"
  with_decryption = true
}
