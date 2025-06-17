output "submit_log_url" {
  value = "https://${aws_api_gateway_rest_api.logs_api.id}.execute-api.${var.aws_region}.amazonaws.com/prod/submit"
}
output "github_actions_role_arn" {
  value = aws_iam_role.github_oidc_lambda_deploy.arn
}
