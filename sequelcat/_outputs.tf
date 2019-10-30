output "command_endpoint" {
  value = "${module.api_gateway.endpoint_url}${local.command_path}"
}
output "interaction_endpoint" {
  value = "${module.api_gateway.endpoint_url}${local.interaction_path}"
}
output "aws_access_key_id_for_ci" {
  value = aws_iam_access_key.ci.id
}
output "aws_secret_access_key_for_ci" {
  value = aws_iam_access_key.ci.secret
}
