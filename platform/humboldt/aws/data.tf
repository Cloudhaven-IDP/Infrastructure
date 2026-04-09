data "aws_ssm_parameter" "tailscale_auth_key" {
  name            = "/restricted/tailscale/auth-key"
  with_decryption = false # EC2 fetches the value at boot — we only need the ARN here
}

data "aws_iam_policy_document" "tailscale_ssm" {
  statement {
    sid       = "ReadParameter"
    effect    = "Allow"
    actions   = ["ssm:GetParameter"]
    resources = [data.aws_ssm_parameter.tailscale_auth_key.arn]
  }

  statement {
    sid       = "DecryptParameter"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:${local.config.region}:*:alias/aws/ssm"]
  }
}

data "aws_ami" "al2023_arm" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}
