output "subnet_ids" {
  value = aws_subnet.subnet.*.id
}

output "sg_id" {
  value = aws_security_group.group.id
}
