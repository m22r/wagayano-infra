module "network" {
  source                  = "../_modules/network"
  prefix                  = local.name
  type                    = "private"
  availability_zones      = data.aws_availability_zones.available.names
  vpc_id                  = local.vpc_id
  vpc_cidr                = data.aws_vpc.vpc.cidr_block
  newbits                 = local.newbits
  netnum_offset           = local.netnum_offset
  private_route_table_ids = data.aws_route_tables.private.ids
  public_route_table_id   = data.aws_route_table.public.id
}

module "mysql_aurora" {
  source             = "../_modules/aurora"
  instance_count     = 1
  prefix             = local.name
  engine             = local.mysql_engine
  engine_version     = local.mysql_engine_version
  availability_zones = data.aws_availability_zones.available.names
  db_name            = local.mysql_db_name
  db_user            = local.mysql_db_user
  db_pass            = local.mysql_db_pass
  vpc_security_group_ids = [
    module.network.sg_id,
  ]
  subnet_ids          = module.network.subnet_ids
  family              = local.mysql_family
  instance_class      = "db.t3.small"
  skip_final_snapshot = true
}

module "postgres_aurora" {
  source             = "../_modules/aurora"
  instance_count     = 1
  prefix             = local.name
  engine             = local.postgres_engine
  engine_version     = local.postgres_engine_version
  availability_zones = data.aws_availability_zones.available.names
  db_name            = local.postgres_db_name
  db_user            = local.postgres_db_user
  db_pass            = local.postgres_db_pass
  vpc_security_group_ids = [
    module.network.sg_id,
  ]
  subnet_ids          = module.network.subnet_ids
  family              = local.postgres_family
  skip_final_snapshot = true
}

module "mysql_rds" {
  source         = "../_modules/rds"
  prefix         = local.name
  engine         = local.mysql_rds_engine
  engine_version = local.mysql_rds_engine_version
  db_name        = local.mysql_rds_db_name
  db_user        = local.mysql_rds_db_user
  db_pass        = local.mysql_rds_db_pass
  vpc_security_group_ids = [
    module.network.sg_id,
  ]
  subnet_ids          = module.network.subnet_ids
  family              = local.mysql_rds_family
  skip_final_snapshot = true
}

module "phoenix_ci_user" {
  source     = "../_modules/iam_user"
  name       = "${local.name}-phoenix-ci"
  iam_policy = data.aws_iam_policy_document.phoenix_ci.json
}

module "rainbows_ci_user" {
  source     = "../_modules/iam_user"
  name       = "${local.name}-rainbows-ci"
  iam_policy = data.aws_iam_policy_document.rainbows_ci.json
}
