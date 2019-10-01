output "endpoint_url" {
  value = "https://${aws_api_gateway_deployment.deployment.rest_api_id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${aws_api_gateway_deployment.deployment.stage_name}"
}
