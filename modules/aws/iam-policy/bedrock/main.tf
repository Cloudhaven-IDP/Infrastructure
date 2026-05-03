locals {
  foundation_model_arns = flatten([
    for region in var.regions : [
      for model in var.allowed_models : "arn:aws:bedrock:${region}::foundation-model/${model}"
    ]
  ])
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "InvokeModels"
    effect = "Allow"
    actions = [
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream",
      "bedrock:Converse",
      "bedrock:ConverseStream",
    ]
    resources = length(local.foundation_model_arns) + length(var.inference_profile_arns) > 0 ? concat(local.foundation_model_arns, var.inference_profile_arns) : ["*"]
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.description
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags
}
