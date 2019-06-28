## General
variable "aws_account_id" {
  type = map(string)

  default = {
    default = "692409969678"
    dev     = "692409969678"
    stg     = "692409969678"
    prd     = "692409969678"
  }
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "product" {
  type    = string
  default = "wagayano"
}

## Network
variable "vpc_cidr" {
  type = map(string)

  default = {
    default = "10.0.0.0/16"
    dev     = "10.1.0.0/16"
    stg     = "10.2.0.0/16"
    prd     = "10.3.0.0/16"
  }
}

## IAM
variable "admin_users" {
  type = list
  default = [
    "player1",
  ]
}
