# This function returns the 100 most recent log entries, sorted by timestamp.

import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('LogEntries')

def lambda_handler(event, context):
    try:
        response = table.scan()

        logs = response.get('Items', [])
        # Sort by timestamp descending
        logs_sorted = sorted(logs, key=lambda x: x['timestamp'], reverse=True)

        return {
            "statusCode": 200,
            "body": json.dumps(logs_sorted[:100])
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
