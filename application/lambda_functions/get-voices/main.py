import json
import boto3

def lambda_handler(event, context):
    voices = getVoices()
    return {
        "body": json.dumps({ "voices": voices })
    }


def getVoices():
    polly = boto3.client("polly")
    response = polly.describe_voices(
        Engine="standard",
        LanguageCode="en-GB",
        IncludeAdditionalLanguageCodes=False,
        NextToken='string'
    )
    return response