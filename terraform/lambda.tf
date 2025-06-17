# Lambda Functions for Submit and Get Logs

resource "aws_lambda_function" "submit_log" {
  function_name    = "submit_log"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.11"
  timeout          = 10
  filename         = "${path.module}/../functions/submit_log/submit_log.zip"
  source_code_hash = filebase64sha256("${path.module}/../functions/submit_log/submit_log.zip")
}

resource "aws_lambda_function" "get_logs" {
  function_name    = "get_logs"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.11"
  timeout          = 10
  filename         = "${path.module}/../functions/get_logs/get_logs.zip"
  source_code_hash = filebase64sha256("${path.module}/../functions/get_logs/get_logs.zip")
}
