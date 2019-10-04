variable "prefix" {}
variable "type" {
  default     = "private"
  description = "private or public"
}
variable "availability_zones" {}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "newbits" {}
variable "netnum_offset" {}
variable "private_route_table_ids" {
  type    = list(string)
  default = []
}
variable "public_route_table_id" {
  default = ""
}
