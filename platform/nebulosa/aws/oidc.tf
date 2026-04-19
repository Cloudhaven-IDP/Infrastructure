resource "aws_iam_openid_connect_provider" "nebulosa" {
  url = "https://oidc-nebulosa.cloudhaven.work"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    data.tls_certificate.nebulosa_oidc.certificates[0].sha1_fingerprint,
  ]
}
