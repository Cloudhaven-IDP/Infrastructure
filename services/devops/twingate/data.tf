

locals {
  twingate_network       = "cloudhaven"
  twingate_api_token     = data.aws_ssm_parameter.twingate_api_token.value
  twingate_access_token  = data.aws_ssm_parameter.twingate_access_token.value
  twingate_refresh_token = data.aws_ssm_parameter.twingate_refresh_token.value
  twingate_resources     = jsondecode(file("${path.module}/values.json"))
}

data "aws_ssm_parameter" "twingate_access_token" {
  name            = "/twingate/access-token"
  with_decryption = true
}

data "aws_ssm_parameter" "twingate_refresh_token" {
  name            = "/twingate/refresh-token"
  with_decryption = true
}

data "aws_ssm_parameter" "twingate_api_token" {
  name            = "/twingate/api-token"
  with_decryption = true

}

import {
  id = "UmVtb3RlTmV0d29yazoyMTkxOTM="
  to = twingate_remote_network.aws
}