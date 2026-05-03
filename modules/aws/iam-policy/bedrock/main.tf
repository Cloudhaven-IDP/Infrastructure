data "aws_iam_policy_document" "this" {
  statement {
    sid    = "InvokeModels"
    effect = "Allow"
    actions = [
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream",
    ]
    resources = length(var.model_ids) == 0 ? ["*"] : flatten([
      for region in var.regions : [
        for id in var.model_ids : "arn:aws:bedrock:${region}::foundation-model/${id}"
      ]
    ])
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.description
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags
}
