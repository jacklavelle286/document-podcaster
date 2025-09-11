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
    2. Get line item from dynamo using job id 
    3. Trigger transcription job using job values
    4. Send output to the output s3 bucket
    '''
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    logger.info(event)
    file_name = event['Records'][0]['s3']['object']['key']

    logger.info(f"file name: {file_name}")

    document_text = docx_to_text(file_name)

    output_bucket_name = os.environ["DESTINATION_BUCKET"]
    file_name_list = file_name.split("/")
    jobId = file_name_list[1]
    logger.info(f"JobId: {jobId}")
    item_attributes = get_item_attributes(jobId=jobId)
    logger.info(f"Item: {item_attributes}")
    voiceId = item_attributes["Item"]["voiceId"]["S"]
    logger.info(f"VoiceId: {voiceId}")
    engine = item_attributes['Item']["engine"]["S"]
    logger.info(f"Engine: {engine}")
    language = item_attributes['Item']["language"]["S"]
    logger.info(f"Language: {language}")

    job = jobToDynamo(jobId=jobId, status="SUCCESS")
    
    response = transcriber(
        engine=engine,
        language=language,
        output_format="mp3",
        s3_bucket=output_bucket_name,
        voiceId=voiceId,
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
    
    

def jobToDynamo(jobId, status):
    dynamodb = boto3.client("dynamodb")
    table_name = os.environ["TABLE_NAME"]
    try:
        resp = dynamodb.update_item(
            TableName=table_name,
            Key={"jobId": {"S": jobId}},
            UpdateExpression="SET #s = :val",
            ExpressionAttributeNames={"#s": "status"},
            ExpressionAttributeValues={":val": {"S": status}}
        )
        return resp
    except Exception as e:
        logging.error(f"Error updating DynamoDB: {e}")
        return None 


def get_item_attributes(jobId):
    dynamodb = boto3.client("dynamodb")
    table_name = os.environ["TABLE_NAME"]
    try:
        resp = dynamodb.get_item(
            TableName = table_name,
            Key={
                "jobId": {"S": jobId}
            }
        )
        return resp
    except Exception as e:
        logging.error(f"Error reading from DynamoDB: {e}")
        return None 

        
