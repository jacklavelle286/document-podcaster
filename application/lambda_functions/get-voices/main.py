import json
import boto3

def lambda_handler(event, context):
    voices = getVoices()
    return voices

def getVoices():
    polly = boto3.client("polly")
    response = polly.describe_voices(
        Engine="standard",
        LanguageCode="en-GB",
        IncludeAdditionalLanguageCodes=False
    )
    return response["Voices"]  
