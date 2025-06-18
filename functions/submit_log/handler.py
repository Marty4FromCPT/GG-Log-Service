import json
import os
import boto3

dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('LOG_TABLE')
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    try:
        response = table.scan()
        items = response.get("Items", [])

        # Sort logs by datetime descending and limit to 100
        sorted_logs = sorted(items, key=lambda x: x['datetime'], reverse=True)[:100]

        return {
            "statusCode": 200,
            "body": json.dumps(sorted_logs)
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
