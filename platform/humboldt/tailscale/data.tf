data "aws_ssm_parameter" "tailscale_api_key" {
  name = "/restricted/tailscale/api-key"
}