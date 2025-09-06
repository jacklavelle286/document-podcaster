import json

def lambda_handler(event, context):
    voices = ["Normal", "Interesting", "Funky"]
    return {
        "body": json.dumps({ "voices": voices })
    }
