import json
import time

def lambda_handler(event, context):
    seconds = 5
    time.sleep(seconds)
    return {
        'statusCode': 200,
        'body': json.dumps(f"Hello from uploader! You waited {seconds} seconds.")
    }
    