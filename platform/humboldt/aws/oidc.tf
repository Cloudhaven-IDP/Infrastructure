resource "aws_iam_openid_connect_provider" "humboldt" {
  url = "https://oidc-humboldt.cloudhaven.work"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    data.tls_certificate.humboldt_oidc.certificates[0].sha1_fingerprint,
  ]
}
