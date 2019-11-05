resource "aws_iam_user" "default" {
  name = var.name
}

resource "aws_iam_access_key" "default" {
  user = aws_iam_user.default.name
}

resource "aws_iam_user_policy" "default" {
  name = "${var.name}-iam-policy"
  user = aws_iam_user.default.name

  policy = var.iam_policy
}
