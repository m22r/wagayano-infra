variable "prefix" {}
variable "vpc_cidr" {}
variable "nat_instance_num" {}
variable "availability_zones" {
  type = list(string)
}
