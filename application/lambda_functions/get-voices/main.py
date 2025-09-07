import json
import boto3

def lambda_handler(event, context):
    language = "en-GB"
    engine = "standard"
    qs = event.get("queryStringParameters") or {}
    if "language" in qs:
        language = qs["language"]
    if "engine" in qs:
        engine = qs["engine"]

    voices = getVoices(language, engine)
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"voices": voices})
    }

def getVoices(language, engine):
    polly = boto3.client("polly")
    response = polly.describe_voices(
        Engine=engine,
        LanguageCode=language,
        IncludeAdditionalLanguageCodes=False
    )
    return [response["Voices"]]
