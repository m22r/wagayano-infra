resource "aws_iam_role" "lambda" {
  name = "${var.name}-lambda-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda" {
  name = var.name
  description = var.description
  policy = var.iam_policy
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}

resource "aws_lambda_function" "lambda" {
  filename = "${path.module}/dummy.zip"
  function_name = var.name
  description = var.description
  role = aws_iam_role.lambda.arn
  handler = var.handler
  runtime = var.runtime
  timeout = var.timeout
  dynamic "vpc_config" {
    for_each = length(var.subnet_ids) > 0 ? [""] : []
    content {
      subnet_ids = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }
  environment {
    variables = var.env_vars
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.retention_in_days
}
