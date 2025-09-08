import json
import logging
import boto3
import os
from botocore.exceptions import ClientError
import random
import datetime
from datetime import timezone

def lambda_handler(event, context):
    '''
    1. Generate Presigned URL and return to client.
    2. Use Presigned URL to upload file to s3.
    '''
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    logger.setLevel(logging.ERROR)

    body = json.loads(event["body"])
    logger.info(f"Body: {body}")

    file_name = body.get("fileName")
    logger.info(f"file name: {file_name}")

    job_id = str(int(datetime.datetime.now(timezone.utc).timestamp()))
    job_id = job_id.replace(" ", "").replace(".", "").replace(":", "").replace("-", "")

    voice_id = body.get("voiceType")
    logger.info(f"voice id: {voice_id}")

    bucketName = os.environ["UPLOAD_BUCKET"]

    url = createPresignedUrl(bucket=bucketName, object_name=file_name, expiration=3600)
    logger.info(f"url response: {url}")
    
    put = jobToDynamo(jobid=job_id, input_key=file_name, voice_id=voice_id, language="en-US", engine="standard")

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "url": url,
            "put_response": put
        })
    }


def createPresignedUrl(bucket, object_name, expiration):
    s3_client = boto3.client('s3')
    object_name = object_name.replace(" ", "")
    logging.info(f"spaces removed: {object_name}")
    try:
        response = s3_client.generate_presigned_url(
            'put_object',
            Params={'Bucket': bucket, 'Key': object_name},
            ExpiresIn=expiration,
        )
        return response 
    except ClientError as e:
        logging.error(f"Error creating presigned url: {e}")
        return None  


def jobToDynamo(jobid, input_key, voice_id, language, engine):
    dynamodb = boto3.client("dynamodb")
    table_name = os.environ["TABLE_NAME"]
    try:
        resp = dynamodb.put_item(
            TableName=table_name,
            Item={
                "jobId": {"S": jobid},
                "status": {"S": "PENDING"},
                "inputKey": {"S": input_key},
                "voiceId": {"S": voice_id},
                "language": {"S": language},
                "engine": {"S": engine}
            }
        )
        return resp  # Returns the response dict if successful
    except Exception as e:
        logging.error(f"Error writing to DynamoDB: {e}")
        return None  # Returns None if there is an error

