import json
import boto3
import logging
import os

def lambda_handler(event, context):
    check = checkStatus("968b867b5d2b45a59b7b71543348fad3")
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from get job!')
    }


def checkStatus(jobId):
    dynamodb = boto3.client("dynamodb")
    table_name = os.environ["TABLE_NAME"]
    try:
        resp = dynamodb.get_item(
            TableName = table_name,
            Key={
                "jobId": {"S": jobId}
            }
        )
        return resp['Item']["status"]["S"]
    except Exception as e:
        logging.error(f"Error reading from DynamoDB: {e}")
        return None 

        
