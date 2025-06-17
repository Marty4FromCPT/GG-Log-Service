resource "aws_lambda_function" "submit_log" {
  function_name    = "submit_log"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.11"
  timeout          = 10
  filename         = "${path.module}/submit_log.zip"
  source_code_hash = filebase64sha256("${path.module}/submit_log.zip")

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.log_entries.name
    }
  }
}

resource "aws_lambda_function" "get_logs" {
  function_name    = "get_logs"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.11"
  timeout          = 10
  filename         = "${path.module}/get_logs.zip"
  source_code_hash = filebase64sha256("${path.module}/get_logs.zip")

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.log_entries.name
    }
  }
}
