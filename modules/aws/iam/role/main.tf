
data "aws_iam_policy_document" "assume_role" {
  count = var.assume_role_policy == null && var.principals != null ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = var.principals != null ? [var.principals] : []
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name        = var.role_name
  path        = var.path
  description = var.description
  assume_role_policy = coalesce(
    var.assume_role_policy,
    try(data.aws_iam_policy_document.assume_role[0].json, null) #? need tp better this logic, gets us over then hump for now
  )
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies

  tags = merge(var.tags, {
    Name = "${var.role_name}"
  })
}

resource "aws_iam_role_policy_attachment" "managed_policy_arns" {
  for_each = toset(var.managed_policies)

  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.managed_policies[each.value].arn
}

resource "aws_iam_role_policy" "inline_policies" {
  for_each = var.inline_policies

  name   = each.key
  role   = aws_iam_role.this.name
  policy = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = "${var.role_name}-profile"
  path = var.path
  role = aws_iam_role.this.name

  tags = var.tags
}


data "aws_iam_policy" "managed_policies" {
  for_each = length(var.managed_policies) > 0 ? toset(var.managed_policies) : toset([])

  name = each.value
}
