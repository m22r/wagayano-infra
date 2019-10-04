module "iam" {
  source         = "./iam"
  admin_users    = local.admin_users
  admin_group    = "admin"
  admin_role     = "admin"
  tfstate_bucket = module.s3.tfstate_bucket
}

module "s3" {
  source         = "./s3"
  tfstate_bucket = "${local.product}-terraform-tfstate"
}

module "vpc" {
  source             = "./vpc"
  prefix             = local.product
  vpc_cidr           = local.vpc_cidr[terraform.workspace]
  availability_zones = data.aws_availability_zones.available.names
  nat_instance_num   = local.nat_instance_num
}
