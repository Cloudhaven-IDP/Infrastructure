data "aws_iam_policy_document" "assume_ec2" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = coalesce(var.iam_role_name, "${var.name}-role")
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json
  tags               = var.tags
}

resource "aws_iam_instance_profile" "this" {
  name = var.instance_profile_name != null ? var.instance_profile_name : "${var.name}-profile"
  role = aws_iam_role.this.name
}
