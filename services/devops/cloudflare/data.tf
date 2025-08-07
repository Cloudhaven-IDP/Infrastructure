locals {
  cloudflare_api_token = data.aws_ssm_parameter.cloudflare_api_token.value

  cloudhaven_dns_records = {
    "atlantis" = {
      type    = "CNAME"
      content = "a459370b25e904b1a8681e9aa80d235f-415409132.us-east-1.elb.amazonaws.com"
    }
    "argocd" = {
      type    = "CNAME"
      content = "ad9a2370613d1483881798179597e845-1324948555.us-east-1.elb.amazonaws.com"
    }
  }
}

data "aws_ssm_parameter" "cloudflare_api_token" {
  name            = "/cloudflare/api-token"
  with_decryption = true
}

data "aws_ssm_parameter" "cloudhaven_zone_id" {
  name            = "/cloudflare/zone-id"
  with_decryption = true
}
