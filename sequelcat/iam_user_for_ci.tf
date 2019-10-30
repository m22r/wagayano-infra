resource "aws_iam_user" "ci" {
  name = "${local.name}-ci"
}

resource "aws_iam_access_key" "ci" {
  user = aws_iam_user.ci.name
}

resource "aws_iam_user_policy" "ci" {
  name = "${local.name}-ci"
  user = aws_iam_user.ci.name

  policy = data.aws_iam_policy_document.lambda.json
}
