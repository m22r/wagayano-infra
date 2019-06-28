module "iam" {
  source         = "./iam"
  admin_users    = var.admin_users
  admin_group    = "admin"
  admin_role     = "admin"
  tfstate_bucket = module.s3.tfstate_bucket
}

module "s3" {
  source         = "./s3"
  tfstate_bucket = "${var.product}-terraform-tfstate"
}
