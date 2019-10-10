output "command_endpoint" {
  value = "${module.api_gateway.endpoint_url}${local.command_path}"
}
output "interaction_endpoint" {
  value = "${module.api_gateway.endpoint_url}${local.interaction_path}"
}
