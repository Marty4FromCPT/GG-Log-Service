# Outputs will be defined here

output "api_endpoint" {
  description = "Base URL for the log service API"
  value       = "${aws_api_gateway_deployment.log_api.invoke_url}"
}