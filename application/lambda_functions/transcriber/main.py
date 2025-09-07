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
    output_bucket_name = os.environ["DESTINATION_BUCKET"]
    logger.info(f"Got s3 bucket name: {output_bucket_name}")
    response = transcriber(
        engine="standard",
        language="en-GB",
        output_format="mp3",
        s3_bucket=output_bucket_name,
        output_prefix="mp3",
        voiceId="Emmma"
    )
    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }



def transcriber(engine, language, output_format, s3_bucket, output_prefix, voiceId):
    polly = boto3.client("polly")
    response = polly.synthesize_speech(
            Engine=engine,
            LanguageCode=language,
            OutputFormat=output_format, 
            OutputS3BucketName=s3_bucket,
            OutputS3KeyPrefix=output_prefix,
            VoiceId=voiceId,
            Text="string"
    )
    
    
