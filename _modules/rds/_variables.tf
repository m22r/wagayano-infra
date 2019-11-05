variable "prefix" {}
variable "engine" {}
variable "engine_version" {}
variable "db_name" {}
variable "db_user" {}
variable "db_pass" {}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
}
variable "enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = []
}
variable "backup_retention_period" {
  default = 1
}
variable "backup_window" {
  default = "18:00-19:00"
}
variable "maintenance_window" {
  default = "sun:19:00-sun:19:30"
}
variable "family" {}
variable "options" {
  type    = map(string)
  default = {}
}
variable "multi_az" {
  type    = bool
  default = false
}
variable "instance_class" {
  default = "db.t3.micro"
}
variable "db_params" {
  type    = map(string)
  default = {}
}
variable "skip_final_snapshot" {
  type    = bool
  default = false
}
