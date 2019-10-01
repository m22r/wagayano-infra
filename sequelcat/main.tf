module "api_gateway" {
  source       = "../_modules/api_gateway"
  name         = local.name
  description  = local.description
  swagger_body = data.template_file.swagger.rendered
  stage_name   = local.stage_name
  lambda_arn   = module.lambda.arn
}

module "lambda" {
  source            = "../_modules/lambda"
  name              = local.name
  description       = local.description
  handler           = local.lambda_handler
  runtime           = local.lambda_runtime
  env_vars          = local.lambda_env_vars
  retention_in_days = local.log_retention_in_days
  iam_policy        = data.aws_iam_policy_document.lambda.json
}
