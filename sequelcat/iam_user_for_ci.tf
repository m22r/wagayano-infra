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

resource "aws_iam_policy" "cd" {
  name   = "${local.name}-cd"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:UpdateFunctionCode"
      ],
      "Effect": "Allow",
      "Resource": "${module.lambda.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "${local.name}-cd"
  users      = ["${aws_iam_user.ci.name}"]
  policy_arn = "${aws_iam_policy.cd.arn}"
}
