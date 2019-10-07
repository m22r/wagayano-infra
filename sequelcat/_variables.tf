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
  lambda_timeout_sec      = 180
  log_retention_in_days   = 30
  stage_name              = "v1"
  project                 = "wagayano"
  vpc_id                  = data.aws_vpc.vpc.id
  newbits                 = 10
  netnum_offset           = 4
  mysql_engine            = "aurora-mysql"
  mysql_engine_version    = "5.7.12"
  mysql_db_name           = "mysql_test"
  mysql_db_user           = "mysql_test"
  mysql_db_pass           = "mysql_test"
  mysql_family            = "aurora-mysql5.7"
  postgres_engine         = "aurora-postgresql"
  postgres_engine_version = "10.7"
  postgres_db_name        = "postgres_test"
  postgres_db_user        = "postgres_test"
  postgres_db_pass        = "postgres_test"
  postgres_family         = "aurora-postgresql10"
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${local.project}-vpc"]
  }
}

data "aws_security_group" "common" {
  name = "${local.project}-common-sg"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_route_tables" "private" {
  vpc_id = local.vpc_id

  filter {
    name   = "tag:Name"
    values = ["${local.project}-private*"]
  }
}

data "aws_route_table" "public" {
  vpc_id = local.vpc_id

  filter {
    name   = "tag:Name"
    values = ["${local.project}-public*"]
  }
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

  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    resources = [
      "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}:function:${local.name}",
      "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}:function:${local.name}:*",
    ]
  }

  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
    ]
    resources = [
      "*",
    ]
  }
}
