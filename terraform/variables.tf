variable "aws_region" {
  default = "us-east-1"
}

variable "lambda_runtime" {
  default = "python3.11"
}

variable "log_table_name" {
  default = "LogEntries"
}

variable "submit_log_function_name" {
  default = "submit-log-function"
}

variable "get_logs_function_name" {
  default = "get-logs-function"
}
