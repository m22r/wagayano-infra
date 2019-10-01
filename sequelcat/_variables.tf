locals {
  app_name       = "sequelcat"
  name           = local.app_name
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = "ap-northeast-1"
  description    = "The API handles queries with slack apps"
  lambda_handler = local.app_name
  lambda_runtime = "go1.x"
  lambda_env_vars = {
    "ENV"   = terraform.workspace
    "TOKEN" = data.aws_ssm_parameter.slack_api_token.value
  }
  lambda_timeout_sec    = 180
  log_retention_in_days = 30
  stage_name            = "v1"
}

data "aws_ssm_parameter" "slack_api_token" {
  name = "/slack/api/token"
}

data "aws_caller_identity" "current" {}

data "template_file" "swagger" {
  template = file("${path.root}/_templates/swagger.yaml")

  vars = {
    description = local.description
    app_name    = local.app_name
    uri_arn     = module.lambda.invoke_arn
  }
}


data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:log-group:/aws/lambda/${local.name}",
      "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:log-group:/aws/lambda/${local.name}:*",
    ]
  }
}
