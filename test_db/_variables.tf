locals {
  app_name                 = "test"
  name                     = "${local.project}-${local.app_name}"
  aws_account_id           = data.aws_caller_identity.current.account_id
  aws_region               = "ap-northeast-1"
  project                  = "wagayano"
  vpc_id                   = data.aws_vpc.vpc.id
  newbits                  = 10
  netnum_offset            = 8
  mysql_engine             = "aurora-mysql"
  mysql_engine_version     = "5.7.12"
  mysql_db_name            = "mysql_test"
  mysql_db_user            = "mysql_test"
  mysql_db_pass            = "mysql_test"
  mysql_family             = "aurora-mysql5.7"
  postgres_engine          = "aurora-postgresql"
  postgres_engine_version  = "10.7"
  postgres_db_name         = "postgres_test"
  postgres_db_user         = "postgres_test"
  postgres_db_pass         = "postgres_test"
  postgres_family          = "aurora-postgresql10"
  mysql_rds_engine         = "mysql"
  mysql_rds_engine_version = "8.0.16"
  mysql_rds_db_name        = "mysql_test"
  mysql_rds_db_user        = "mysql_test"
  mysql_rds_db_pass        = "mysql_test"
  mysql_rds_family         = "mysql8.0"
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

data "aws_caller_identity" "current" {}
