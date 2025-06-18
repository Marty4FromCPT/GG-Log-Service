provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

# DynamoDB table
resource "aws_dynamodb_table" "log_entries" {
  name         = "LogEntries"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "datetime"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "datetime"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name = "LogEntries"
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name = "lambda_dynamodb_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:Scan"
        ],
        Resource = aws_dynamodb_table.log_entries.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

# Lambda Functions
resource "aws_lambda_function" "submit_log" {
  function_name = "submit-log-function"
  filename      = "../functions/submit_log.zip"
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 10
  source_code_hash = filebase64sha256("../functions/submit_log.zip")

  environment {
    variables = {
      LOG_TABLE = aws_dynamodb_table.log_entries.name
    }
  }
}

resource "aws_lambda_function" "get_logs" {
  function_name = "get-logs-function"
  filename      = "../functions/get_logs.zip"
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 10
  source_code_hash = filebase64sha256("../functions/get_logs.zip")

  environment {
    variables = {
      LOG_TABLE = aws_dynamodb_table.log_entries.name
    }
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "log_api" {
  name        = "log-api"
  description = "API for log submission and retrieval"
}

resource "aws_api_gateway_resource" "submit" {
  rest_api_id = aws_api_gateway_rest_api.log_api.id
  parent_id   = aws_api_gateway_rest_api.log_api.root_resource_id
  path_part   = "submit"
}

resource "aws_api_gateway_resource" "logs" {
  rest_api_id = aws_api_gateway_rest_api.log_api.id
  parent_id   = aws_api_gateway_rest_api.log_api.root_resource_id
  path_part   = "logs"
}

resource "aws_api_gateway_method" "submit_post" {
  rest_api_id   = aws_api_gateway_rest_api.log_api.id
  resource_id   = aws_api_gateway_resource.submit.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "logs_get" {
  rest_api_id   = aws_api_gateway_rest_api.log_api.id
  resource_id   = aws_api_gateway_resource.logs.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "submit_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.log_api.id
  resource_id             = aws_api_gateway_resource.submit.id
  http_method             = aws_api_gateway_method.submit_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.submit_log.invoke_arn
}

resource "aws_api_gateway_integration" "logs_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.log_api.id
  resource_id             = aws_api_gateway_resource.logs.id
  http_method             = aws_api_gateway_method.logs_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_logs.invoke_arn
}

# Lambda permissions for API Gateway
resource "aws_lambda_permission" "allow_submit" {
  statement_id  = "AllowSubmitAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.submit_log.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.log_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_logs" {
  statement_id  = "AllowLogsAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_logs.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.log_api.execution_arn}/*/*"
}

# Deployment and stage (non-deprecated)
resource "aws_api_gateway_deployment" "log_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.submit_lambda,
    aws_api_gateway_integration.logs_lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.log_api.id
  description = "Log API Deployment"
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.log_api.id
  deployment_id = aws_api_gateway_deployment.log_api_deployment.id
}

# Outputs
output "submit_log_url" {
  value = "https://${aws_api_gateway_rest_api.log_api.id}.execute-api.us-east-1.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}/submit"
}

output "get_logs_url" {
  value = "https://${aws_api_gateway_rest_api.log_api.id}.execute-api.us-east-1.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}/logs"
}
