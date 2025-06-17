# REST API Integration

resource "aws_api_gateway_rest_api" "log_api" {
  name = "LogServiceAPI"
}

resource "aws_api_gateway_resource" "log_resource" {
  rest_api_id = aws_api_gateway_rest_api.log_api.id
  parent_id   = aws_api_gateway_rest_api.log_api.root_resource_id
  path_part   = "logs"
}

# POST /logs
resource "aws_api_gateway_method" "post_logs" {
  rest_api_id   = aws_api_gateway_rest_api.log_api.id
  resource_id   = aws_api_gateway_resource.log_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_logs_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.log_api.id
  resource_id             = aws_api_gateway_resource.log_resource.id
  http_method             = aws_api_gateway_method.post_logs.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.submit_log.invoke_arn
}

# GET /logs
resource "aws_api_gateway_method" "get_logs" {
  rest_api_id   = aws_api_gateway_rest_api.log_api.id
  resource_id   = aws_api_gateway_resource.log_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_logs_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.log_api.id
  resource_id             = aws_api_gateway_resource.log_resource.id
  http_method             = aws_api_gateway_method.get_logs.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_logs.invoke_arn
}

resource "aws_lambda_permission" "allow_post" {
  statement_id  = "AllowExecutionFromAPIGatewayPost"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.submit_log.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.log_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_get" {
  statement_id  = "AllowExecutionFromAPIGatewayGet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_logs.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.log_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "log_api" {
  depends_on = [
    aws_api_gateway_integration.post_logs_lambda,
    aws_api_gateway_integration.get_logs_lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.log_api.id
  stage_name  = "prod"
}
