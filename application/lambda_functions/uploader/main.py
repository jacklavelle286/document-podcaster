import json
import logging
import boto3
import os
from botocore.exceptions import ClientError
import uuid


def lambda_handler(event, context):
    '''
    1. Generate Presigned URL and return to client.
    2. Use Presigned URL to upload file to s3.
    '''
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    body = json.loads(event["body"])

    file_name = body.get("fileName")
    logger.info(f"file name: {file_name}")

    voice_id = body.get("voiceType")
    logger.info(f"voice id: {voice_id}")

    bucketName = os.environ["UPLOAD_BUCKET"]
    jobId = uuid.uuid4().hex
    url, object_key = createPresignedUrl(bucket=bucketName, jobId=jobId, object_name=file_name, expiration=3600)
    logger.info(f"url response: {url}")

    jobToDynamo(jobId=jobId, input_key=object_key, voice_id=voice_id, language="en-US", engine="standard")

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "jobId": jobId,
            "objectKey": object_key,
            "url": url
        })
    }


def createPresignedUrl(bucket, object_name, jobId, expiration):
    s3_client = boto3.client('s3')
    safe_name = object_name.replace(" ", "")
    safe_name = safe_name.replace("-", "")
    safe_name = safe_name.replace("_", "")
    object_key = f"uploads/{jobId}/{safe_name}"
    try:
        url = s3_client.generate_presigned_url(
            'put_object',
            Params={'Bucket': bucket, 'Key': object_key},
            ExpiresIn=expiration,
        )
        return url, object_key
    
    except ClientError as e:
        logging.error(f"Error creating presigned url: {e}")
        return None, None


def jobToDynamo(jobId, input_key, voice_id, language, engine):
    dynamodb = boto3.client("dynamodb")
    table_name = os.environ["TABLE_NAME"]
    try:
        resp = dynamodb.put_item(
            TableName=table_name,
            Item={
                "jobId": {"S": jobId},
                "status": {"S": "PENDING"},
                "inputKey": {"S": input_key},
                "voiceId": {"S": voice_id},
                "language": {"S": language},
                "engine": {"S": engine}
            }
        )
        return resp  
    except Exception as e:
        logging.error(f"Error writing to DynamoDB: {e}")
        return None 


