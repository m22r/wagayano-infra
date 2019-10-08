variable "name" {}
variable "description" {}
variable "handler" {}
variable "runtime" {}
variable "env_vars" {
  type = map(string)
  default = {
    "ENV" = "default"
  }
}
variable "retention_in_days" {
  type    = string
  default = 30
}
variable "iam_policy" {}
variable "subnet_ids" {
  type    = list(string)
  default = []
}
variable "security_group_ids" {
  type    = list(string)
  default = []
}
variable "timeout" {
  default = 3
}
