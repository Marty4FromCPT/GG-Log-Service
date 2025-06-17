# Outputs will be defined here

output "api_endpoint" {
  description = "Base URL of the API Gateway"
  value       = "https://${aws_api_gateway_rest_api.log_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.log_stage.stage_name}"
}
