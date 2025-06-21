provider "aws" {
  region  = local.aws_region
  version = "~> 6.0"
}

provider "template" {
  version = "~> 2.1"
}
