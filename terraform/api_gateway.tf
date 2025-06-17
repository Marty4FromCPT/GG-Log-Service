resource "aws_api_gateway_rest_api" "log_api" {
  name        = "LogServiceAPI"
  description = "API Gateway for submitting and retrieving log entries"
}

resource "aws_api_gateway_resource" "logs_resource" {
  rest_api_id = aws_api_gateway_rest_api.log_api.id
  parent_id   = aws_api_gateway_rest_api.log_api.root_resource_id
  path_part   = "logs"
}

# === POST /logs ===
resource "aws_api_gateway_method" "post_logs" {
  rest_api_id      = aws_api_gateway_rest_api.log_api.id
  resource_id      = aws_api_gateway_resource.logs_resource.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "post_logs_integration" {
  rest_api_id             = aws_api_gateway_rest_api.log_api.id
  resource_id             = aws_api_gateway_resource.logs_resource.id
  http_method             = aws_api_gateway_method.post_logs.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.submit_log.invoke_arn
}

# === GET /logs ===
resource "aws_api_gateway_method" "get_logs" {
  rest_api_id      = aws_api_gateway_rest_api.log_api.id
  resource_id      = aws_api_gateway_resource.logs_resource.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "get_logs_integration" {
  rest_api_id             = aws_api_gateway_rest_api.log_api.id
  resource_id             = aws_api_gateway_resource.logs_resource.id
  http_method             = aws_api_gateway_method.get_logs.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_logs.invoke_arn
}

# === Deployment (no stage_name here) ===
resource "aws_api_gateway_deployment" "log_api" {
  rest_api_id = aws_api_gateway_rest_api.log_api.id

  depends_on = [
    aws_api_gateway_integration.post_logs_integration,
    aws_api_gateway_integration.get_logs_integration
  ]
}

# === Stage ===
resource "aws_api_gateway_stage" "log_stage" {
  rest_api_id   = aws_api_gateway_rest_api.log_api.id
  deployment_id = aws_api_gateway_deployment.log_api.id
  stage_name    = "prod"
}

# === API Key ===
resource "aws_api_gateway_api_key" "log_api_key" {
  name    = "LogServiceAPIKey"
  enabled = true
  value   = "log-service-key-123"
}

# === Usage Plan ===
resource "aws_api_gateway_usage_plan" "log_plan" {
  name = "LogServiceUsagePlan"

  api_stages {
    api_id = aws_api_gateway_rest_api.log_api.id
    stage  = aws_api_gateway_stage.log_stage.stage_name
  }

  throttle_settings {
    rate_limit  = 10
    burst_limit = 5
  }

  quota_settings {
    limit  = 10000
    period = "MONTH"
  }
}

resource "aws_api_gateway_usage_plan_key" "log_plan_key" {
  key_id        = aws_api_gateway_api_key.log_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.log_plan.id
}

# === Method Settings for Logging ===
resource "aws_api_gateway_method_settings" "log_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.log_api.id
  stage_name  = aws_api_gateway_stage.log_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled     = true
    logging_level       = "INFO"
    data_trace_enabled  = false
  }
}
