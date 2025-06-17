resource "aws_dynamodb_table" "log_table" {
  name         = var.log_table_name
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
    enabled     = true
    kms_master_key_id = "alias/aws/dynamodb"
  }

  tags = {
    Name = var.log_table_name
  }
}
