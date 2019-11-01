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

module "mysql_aurora" {
  source             = "../_modules/aurora"
  instance_count     = 1
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

module "postgres_aurora" {
  source             = "../_modules/aurora"
  instance_count     = 1
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

module "mysql_rds" {
  source         = "../_modules/rds"
  prefix         = "${local.project}-${local.name}"
  engine         = local.mysql_rds_engine
  engine_version = local.mysql_rds_engine_version
  db_name        = local.mysql_rds_db_name
  db_user        = local.mysql_rds_db_user
  db_pass        = local.mysql_rds_db_pass
  vpc_security_group_ids = [
    module.network.sg_id,
  ]
  subnet_ids = module.network.subnet_ids
  family     = local.mysql_rds_family
}
