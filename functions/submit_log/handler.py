# This function receives a log entry via HTTP POST, validates it, and writes it to DynamoDB.

import json
import uuid
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('LogEntries')  # match your var.log_table_name

def lambda_handler(event, context):
    try:
        body = json.loads(event.get('body', '{}'))
        severity = body.get('severity')
        message = body.get('message')

        if severity not in ["info", "warning", "error"]:
            return {"statusCode": 400, "body": json.dumps({"error": "Invalid severity"})}

        log_entry = {
            "id": str(uuid.uuid4()),
            "timestamp": datetime.utcnow().isoformat(),
            "severity": severity,
            "message": message
        }

        table.put_item(Item=log_entry)

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Log saved", "log": log_entry})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
