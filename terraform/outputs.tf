output "submit_log_url" {
  value = "https://${aws_api_gateway_rest_api.logs_api.id}.execute-api.${var.aws_region}.amazonaws.com/prod/submit"
}
