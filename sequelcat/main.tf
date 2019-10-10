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
  timeout           = local.lambda_timeout_sec
  iam_policy        = data.aws_iam_policy_document.lambda.json
  subnet_ids        = module.network.subnet_ids
  security_group_ids = [
    data.aws_security_group.common.id,
    module.network.sg_id,
  ]
}

module "network" {
  source                  = "../_modules/network"
  prefix                  = "${local.project}-${local.name}"
  type                    = "private"
  availability_zones      = data.aws_availability_zones.available.names
  vpc_id                  = local.vpc_id
  vpc_cidr                = data.aws_vpc.vpc.cidr_block
  newbits                 = local.newbits
  netnum_offset           = local.netnum_offset
  private_route_table_ids = data.aws_route_tables.private.ids
  public_route_table_id   = data.aws_route_table.public.id
}

module "mysql" {
  source             = "../_modules/aurora"
  prefix             = "${local.project}-${local.name}"
  engine             = local.mysql_engine
  engine_version     = local.mysql_engine_version
  availability_zones = data.aws_availability_zones.available.names
  db_name            = local.mysql_db_name
  db_user            = local.mysql_db_user
  db_pass            = local.mysql_db_pass
  vpc_security_group_ids = [
    module.network.sg_id,
  ]
  subnet_ids     = module.network.subnet_ids
  family         = local.mysql_family
  instance_class = "db.t3.small"
}

module "postgres" {
  source             = "../_modules/aurora"
  prefix             = "${local.project}-${local.name}"
  engine             = local.postgres_engine
  engine_version     = local.postgres_engine_version
  availability_zones = data.aws_availability_zones.available.names
  db_name            = local.postgres_db_name
  db_user            = local.postgres_db_user
  db_pass            = local.postgres_db_pass
  vpc_security_group_ids = [
    module.network.sg_id,
  ]
  subnet_ids = module.network.subnet_ids
  family     = local.postgres_family
}

module "parameters" {
  source     = "../_modules/ssm_parameters"
  parameters = local.ssm_parameters
}

module "s3" {
  source = "../_modules/s3"
  name   = "${local.project}-${local.name}"
}
