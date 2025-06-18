import json
import boto3
import uuid
from datetime import datetime
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['LOG_TABLE'])

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])

        log_entry = {
            'id': str(uuid.uuid4()),
            'datetime': datetime.utcnow().isoformat(),
            'severity': body.get('severity', 'info'),
            'message': body.get('message', '')
        }

        table.put_item(Item=log_entry)

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Log entry saved successfully.',
                'log': log_entry
            }),
            'headers': {
                'Content-Type': 'application/json'
            }
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)}),
            'headers': {
                'Content-Type': 'application/json'
            }
        }
