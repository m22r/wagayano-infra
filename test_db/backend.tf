terraform {
  backend "s3" {
    bucket = "wagayano-terraform-tfstate"
    key    = "wagayano-testdb/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
