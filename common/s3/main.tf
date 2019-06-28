resource "aws_s3_bucket" "tfstate" {
  bucket = var.tfstate_bucket
  acl    = "private"
  tags = {
    Name = var.tfstate_bucket
  }
}
