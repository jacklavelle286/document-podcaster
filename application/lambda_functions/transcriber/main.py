import json
import logging
import boto3
import os
from botocore.exceptions import ClientError


def lambda_handler(event, context):
    '''
    1. Get event from s3 upload
    2. Trigger transcription job
    3. Send output to an output s3 bucket
    '''
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    logger.info(event)
    file_name = event['Records'][0]['s3']['object']['key']
    local_file_path = docx_to_text(file_name)
    with open(local_file_path, "r") as f:
        first_line = f.readline()

    logger.info(f"First line is: {first_line}")
    logger.info(f"Downloaded file to: {local_file_path}")
    output_bucket_name = os.environ["DESTINATION_BUCKET"]
    logger.info(f"Got s3 bucket name: {output_bucket_name}")
    response = transcriber(
        engine="standard",
        language="en-GB",
        output_format="mp3",
        s3_bucket=output_bucket_name,
        voiceId="Emma"
    )
    logger.info(f"Response: {response}")
    return {
        'statusCode': 200,
        'body': json.dumps(response, default=str)
    }

def docx_to_text(key: str) -> str:
    s3 = boto3.client("s3")
    bucket = os.environ["UPLOAD_BUCKET"]
    obj = s3.get_object(Bucket=bucket, Key=key)
    body = obj["Body"].read()         # bytes
    local_path = f"/tmp/{os.path.basename(key)}"
    with open(local_path, "wb") as f: # write bytes
        f.write(body)
    return local_path

    


def transcriber(engine, language, output_format, s3_bucket, voiceId):
    polly = boto3.client("polly")
    response = polly.start_speech_synthesis_task(
            Engine=engine,
            LanguageCode=language,
            OutputFormat=output_format, 
            OutputS3BucketName=s3_bucket,
            VoiceId=voiceId,
            Text="string"
    )

    return response
    
    

data = {'Records': [{'eventVersion': '2.1', 'eventSource': 'aws:s3', 'awsRegion': 'eu-west-2', 'eventTime': '2025-09-07T17:54:18.417Z', 'eventName': 'ObjectCreated:Put', 'userIdentity': {'principalId': 'AWS:AROAZOW6U4XNNEOXYQCC6:document-podcastor-poc-eu-west-2-uploader'}, 'requestParameters': {'sourceIPAddress': '81.159.120.59'}, 'responseElements': {'x-amz-request-id': '2P7M2DNQHNCSJA2A', 'x-amz-id-2': 'B8TdJy0jZzGjTgauoRAy6KF++ZU1oz8m2RBoAThx5vY/S2wwlDijBwXhYGxtKBB+uXwta3BPum246VmasMCxDaTEgZaSAD0s'}, 's3': {'s3SchemaVersion': '1.0', 'configurationId': 'tf-s3-lambda-20250906172940190100000001', 'bucket': {'name': 'document-podcastor-poc-eu-west-2-upload', 'ownerIdentity': {'principalId': 'A2U57DJ495TJCD'}, 'arn': 'arn:aws:s3:::document-podcastor-poc-eu-west-2-upload'}, 'object': {'key': 'JL-CV-AWS-Latest.docx', 'size': 18252, 'eTag': '02e7bf9f206c85a04b094ffbf86187f6', 'sequencer': '0068BDC6CA617DD210'}}}]}

bucket_name = data['Records'][0]['s3']['bucket']['name']
file_name = data['Records'][0]['s3']['object']['key']
print(bucket_name)
print(file_name)
