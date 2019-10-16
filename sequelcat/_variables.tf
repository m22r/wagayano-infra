locals {
  app_name         = "sequelcat"
  name             = local.app_name
  aws_account_id   = data.aws_caller_identity.current.account_id
  aws_region       = "ap-northeast-1"
  description      = "The API handles queries with slack apps"
  command_path     = "/api/command"
  interaction_path = "/api/interaction"
  lambda_handler   = local.app_name
  lambda_runtime   = "go1.x"
  lambda_env_vars = {
    "ENV"                     = terraform.workspace
    "TOKEN"                   = data.aws_ssm_parameter.slack_api_token.value
    "SSM_PARAMETER_BASE_PATH" = "/${local.name}"
    "CHANNEL"                 = "CHTL6PWNS"
    "S3_BUCKET"               = module.s3.id
    "S3_BASE_DIR"             = "/${local.name}"
    "ALLOW_SELF_APPROVE"      = "1"
    "QUERY_TIMEOUT"           = floor(local.lambda_timeout_sec * 0.9)
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
  ssm_parameters = [
    {
      key   = "/${local.name}/cluster/${module.mysql.cluster_id}/db_user"
      value = "${local.mysql_db_user}"
      type  = "String"
    },
    {
      key   = "/${local.name}/cluster/${module.mysql.cluster_id}/db_pass"
      value = "${local.mysql_db_pass}"
      type  = "SecureString"
    },
    #    {
    #      key   = "/${local.name}/instance/${module.mysql.instance_ids[0]}/db_user"
    #      value = "${local.mysql_db_user}"
    #      type  = "String"
    #    },
    #    {
    #      key   = "/${local.name}/instance/${module.mysql.instance_ids[0]}/db_pass"
    #      value = "${local.mysql_db_pass}"
    #      type  = "SecureString"
    #    },
    {
      key   = "/${local.name}/cluster/${module.postgres.cluster_id}/db_user"
      value = "${local.postgres_db_user}"
      type  = "String"
    },
    {
      key   = "/${local.name}/cluster/${module.postgres.cluster_id}/db_pass"
      value = "${local.postgres_db_pass}"
      type  = "SecureString"
    },
    #    {
    #      key   = "/${local.name}/instance/${module.postgres.instance_ids[0]}/db_user"
    #      value = "${local.postgres_db_user}"
    #      type  = "String"
    #    },
    #    {
    #      key   = "/${local.name}/instance/${module.postgres.instance_ids[0]}/db_pass"
    #      value = "${local.postgres_db_pass}"
    #      type  = "SecureString"
    #    }
  ]
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
    interaction_path = local.interaction_path
    command_path     = local.command_path
    description      = local.description
    app_name         = local.app_name
    uri_arn          = module.lambda.invoke_arn
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

  statement {
    actions = [
      "rds:DescribeDBInstances",
      "rds:DescribeDBClusters",
    ]
    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ssm:GetParameter",
    ]
    resources = [
      "arn:aws:ssm:${local.aws_region}:${local.aws_account_id}:parameter/${local.name}/*",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]
    resources = [
      module.s3.arn,
      "${module.s3.arn}/*",
    ]
  }
}
