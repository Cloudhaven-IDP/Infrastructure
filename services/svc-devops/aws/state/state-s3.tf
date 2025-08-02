module "state" {
  source      = "../../../../modules/aws/s3"


  bucket_name = "my-unique-s3-bucket-name"
  bucket_policy = data.aws_iam_policy_document.tf_backend.json

}


data "aws_iam_policy_document" "tf_backend" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::your-tf-backend-bucket",
      "arn:aws:s3:::your-tf-backend-bucket/*"
    ]

    effect = "Allow"
  }

  statement {
    actions = ["dynamodb:*"]

    resources = [
      "arn:aws:dynamodb:<region>:<account_id>:table/your-tf-lock-table"
    ]

    effect = "Allow"
  }
}
