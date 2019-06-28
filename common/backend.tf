terraform {
  backend "s3" {
    bucket = "wagayano-terraform-tfstate"
    key    = "wagayano-common/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
