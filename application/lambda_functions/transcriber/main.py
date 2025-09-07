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

    local_file_path = docx_to_text("variables.tf")
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
    
    