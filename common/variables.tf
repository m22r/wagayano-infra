locals {
  aws_account_id = {
    default = "692409969678"
    dev     = "692409969678"
    stg     = "692409969678"
    prd     = "692409969678"
  }
  aws_region = "ap-northeast-1"
  product    = "wagayano"
  vpc_cidr = {
    default = "10.0.0.0/16"
    dev     = "10.1.0.0/16"
    stg     = "10.2.0.0/16"
    prd     = "10.3.0.0/16"
  }
  nat_instance_num = 1
  admin_users = [
    "player1",
  ]
}

data "aws_availability_zones" "available" {
  state = "available"
}
