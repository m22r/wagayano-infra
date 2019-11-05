variable "prefix" {}
variable "engine" {}
variable "engine_version" {}
variable "availability_zones" {
  type = list(string)
}
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
variable "preferred_backup_window" {
  default = "18:00-19:00"
}
variable "preferred_maintenance_window" {
  default = "sun:19:00-sun:19:30"
}
variable "family" {}
variable "cluster_params" {
  type    = map(string)
  default = {}
}
variable "instance_count" {
  default = 1
}
variable "instance_class" {
  default = "db.t3.medium"
}
variable "db_params" {
  type    = map(string)
  default = {}
}
variable "skip_final_snapshot" {
  type    = bool
  default = false
}
