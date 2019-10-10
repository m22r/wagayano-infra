resource "aws_ssm_parameter" "parameter" {
  count = length(var.parameters)
  name  = var.parameters[count.index].key
  type  = var.parameters[count.index].type
  value = var.parameters[count.index].value
}
