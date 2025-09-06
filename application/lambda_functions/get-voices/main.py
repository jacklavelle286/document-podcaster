import json

def lambda_handler(event, context):
    voices = ["Normal", "Interesting", "Funky"]
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
        },
        "body": json.dumps({ "voices": voices })
    }
