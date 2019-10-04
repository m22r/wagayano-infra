provider "aws" {
  region  = local.aws_region
  version = "~> 2.15"
}

provider "template" {
  version = "~> 2.1"
}
