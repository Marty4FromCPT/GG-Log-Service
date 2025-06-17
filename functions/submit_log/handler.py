import json
import os
import uuid
from datetime import datetime
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['LOG_TABLE'])

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])

        severity = body.get('severity')
        message = body.get('message')

        if severity not in ['info', 'warning', 'error']:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Invalid severity level. Use info, warning, or error."})
            }

        if not message:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing message field."})
            }

        log_entry = {
            "id": str(uuid.uuid4()),
            "datetime": datetime.utcnow().isoformat(),
            "severity": severity,
            "message": message
        }

        table.put_item(Item=log_entry)

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Log entry saved successfully.", "log": log_entry})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
