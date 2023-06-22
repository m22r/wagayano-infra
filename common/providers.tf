provider "aws" {
  region  = local.aws_region
  version = "~> 5.0"
}

provider "template" {
  version = "~> 2.1"
}
