import json
import logging
import boto3
import os
import docx
from io import BytesIO
from botocore.exceptions import ClientError


def lambda_handler(event, context):
    '''
    1. Get event from s3 upload
    2. Trigger transcription job
    3. Send output to an output s3 bucket
    '''
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    file_name = event['Records'][0]['s3']['object']['key']
    logger.info(f"file name: {file_name}")
    document_text = docx_to_text(file_name)
    output_bucket_name = os.environ["DESTINATION_BUCKET"]
    logger.info(f"Got s3 bucket name: {output_bucket_name}")
    response = transcriber(
        engine="standard",
        language="en-GB",
        output_format="mp3",
        s3_bucket=output_bucket_name,
        voiceId="Emma",
        input_text=document_text
    )
    logger.info(f"Response: {response}")
    return {
        'statusCode': 200,
        'body': json.dumps(response, default=str)
    }

def docx_to_text(key: str) -> str:
    s3 = boto3.client("s3")
    bucket = os.environ["UPLOAD_BUCKET"]
    body = s3.get_object(Bucket=bucket, Key=key)["Body"].read()
    local_path = os.path.join("/tmp", os.path.basename(key))
    with open(local_path, "wb") as f:
        f.write(body)
    doc = docx.Document(local_path)
    full_text = [p.text for p in doc.paragraphs]
    text = "\n".join(full_text)
    return text


    


def transcriber(engine, language, output_format, s3_bucket, voiceId, input_text):
    polly = boto3.client("polly")
    response = polly.start_speech_synthesis_task(
            Engine=engine,
            LanguageCode=language,
            OutputFormat=output_format, 
            OutputS3BucketName=s3_bucket,
            VoiceId=voiceId,
            Text=input_text
    )

    return response
    
    