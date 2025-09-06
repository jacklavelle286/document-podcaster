import json
import logging
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    body = json.loads(event["body"])
    voice_type = body.get("voiceType")
    file_name = body.get("fileName")

    print(f"Voice type: {voice_type}")
    print(f"file Name: {file_name}")

    url = createPresignedUrl(bucket="document-podcastor-poc-eu-west-2-upload", object_name="file", expiration=3600)


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
