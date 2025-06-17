resource "aws_api_gateway_rest_api" "logs_api" {
  name = "LogsAPI"
}

resource "aws_api_gateway_resource" "submit" {
  rest_api_id = aws_api_gateway_rest_api.logs_api.id
  parent_id   = aws_api_gateway_rest_api.logs_api.root_resource_id
  path_part   = "submit"
}

resource "aws_api_gateway_resource" "get" {
  rest_api_id = aws_api_gateway_rest_api.logs_api.id
  parent_id   = aws_api_gateway_rest_api.logs_api.root_resource_id
  path_part   = "logs"
}

resource "aws_api_gateway_method" "submit_post" {
  rest_api_id   = aws_api_gateway_rest_api.logs_api.id
  resource_id   = aws_api_gateway_resource.submit.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "submit_integration" {
  rest_api_id = aws_api_gateway_rest_api.logs_api.id
  resource_id = aws_api_gateway_resource.submit.id
  http_method = aws_api_gateway_method.submit_post.http_method
  integration_http_method = "POST"
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.submit_log.invoke_arn
}

resource "aws_api_gateway_method" "get_logs" {
  rest_api_id   = aws_api_gateway_rest_api.logs_api.id
  resource_id   = aws_api_gateway_resource.get.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_logs_integration" {
  rest_api_id = aws_api_gateway_rest_api.logs_api.id
  resource_id = aws_api_gateway_resource.get.id
  http_method = aws_api_gateway_method.get_logs.http_method
  integration_http_method = "POST"
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.get_logs.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_submit" {
  statement_id  = "AllowAPIGatewayInvokeSubmit"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.submit_log.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.logs_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_get" {
  statement_id  = "AllowAPIGatewayInvokeGet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_logs.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.logs_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "logs_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.submit_integration,
    aws_api_gateway_integration.get_logs_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.logs_api.id
  stage_name  = "prod"
}
