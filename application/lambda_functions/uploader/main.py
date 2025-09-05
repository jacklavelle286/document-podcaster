import json

def lambda_handler(event, context):
    body = json.loads(event["body"])
    voice_type = body.get("voiceType")
    file_name = body.get("fileName")

    print(f"Voice type: {voice_type}")
    print(f"file Name: {file_name}")

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "recievedVoiceType": voice_type,
            "recievedFileName": file_name
        })
    }
