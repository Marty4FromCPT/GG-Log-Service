output "submit_log_url" {
  value = aws_api_gateway_deployment.logs_api_deployment.invoke_url
}

output "log_table_name" {
  value = var.log_table_name
}
