data "tls_certificate" "k3s_oidc" {
  url = "https://oidc.cloudhaven.work"
}


resource "aws_iam_openid_connect_provider" "pi-oidc" {
  url = "https://oidc.cloudhaven.work"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    data.tls_certificate.k3s_oidc.certificates[0].sha1_fingerprint,
  ]
}
