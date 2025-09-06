import json
import boto3

def lambda_handler(event, context):
    voices = getVoices()
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"voices": voices})
    }

def getVoices():
    polly = boto3.client("polly")
    response = polly.describe_voices(
        Engine="standard",
        LanguageCode="en-GB",
        IncludeAdditionalLanguageCodes=False
    )
    return [v["Name"] for v in response["Voices"]]
