provider "aws" {
  region  = var.aws_region
  version = "~> 2.15"
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id[terraform.workspace]}:role/admin"
    session_name = "terraform"
  }
}

provider "template" {
  version = "~> 2.1"
}
