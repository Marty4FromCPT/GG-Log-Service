# This function returns the 100 most recent log entries, sorted by timestamp.

import json
import os
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['LOG_TABLE'])

def lambda_handler(event, context):
    try:
        response = table.scan()

        logs = response.get('Items', [])

        # Sort by datetime descending
        logs.sort(key=lambda x: x.get("datetime", ""), reverse=True)

        # Return the most recent 100 logs
        return {
            "statusCode": 200,
            "body": json.dumps(logs[:100])
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
