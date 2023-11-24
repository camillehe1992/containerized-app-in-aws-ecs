resource "aws_iam_role" "this" {
  name               = var.role_name
  description        = var.role_description
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = var.aws_managed_policy_arns

  role       = aws_iam_role.this.name
  policy_arn = each.key
}

resource "aws_iam_policy" "customized_policies" {
  for_each = var.customized_policies

  name   = "${aws_iam_role.this.name}-${each.key}"
  policy = each.value
}

resource "aws_iam_role_policy_attachment" "customized" {
  for_each = aws_iam_policy.customized_policies

  role       = aws_iam_role.this.name
  policy_arn = each.value.arn
}

resource "aws_iam_instance_profile" "this" {
  count = var.has_iam_instance_profile ? 1 : 0
  name  = aws_iam_role.this.name
  role  = aws_iam_role.this.name
}
