resource "aws_lambda_function" "submit_log" {
  function_name = var.submit_log_function_name
  filename      = "../functions/submit_log.zip"
  handler       = "handler.lambda_handler"
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("../functions/submit_log.zip")
  timeout       = 10

  environment {
    variables = {
      LOG_TABLE = var.log_table_name
    }
  }
}

resource "aws_lambda_function" "get_logs" {
  function_name = var.get_logs_function_name
  filename      = "../functions/get_logs.zip"
  handler       = "handler.lambda_handler"
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("../functions/get_logs.zip")
  timeout       = 10

  environment {
    variables = {
      LOG_TABLE = var.log_table_name
    }
  }
}
