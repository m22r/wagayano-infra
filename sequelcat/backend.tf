terraform {
  backend "s3" {
    bucket = "wagayano-terraform-tfstate"
    key    = "wagayano-sequelcat/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
