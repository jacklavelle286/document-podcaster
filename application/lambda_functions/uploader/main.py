import json
import logging
import boto3
import os
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    '''
    1. Generate Presigned URL and return to client.
    2. Use Presigned URL to upload file to s3.
    '''
    body = json.loads(event["body"])
    file_name = body.get("fileName")
    logging.BASIC_FORMAT(f"File name: {file_name}")

    bucketName = os.environ("UPLOAD_BUCKET")
    logging.BASIC_FORMAT(f"BucketName: {bucketName}")
    url = createPresignedUrl(bucket=bucketName, object_name=file_name, expiration=3600)


    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "url": url
        })
    }


def createPresignedUrl(bucket, object_name, expiration):
    s3_client = boto3.client('s3')
    try:
        response = s3_client.generate_presigned_url(
            'get_object',
            Params={'Bucket': bucket, 'Key': object_name},
            ExpiresIn=expiration,
        )
    except ClientError as e:
        logging.error(e)
        return None
    return response
