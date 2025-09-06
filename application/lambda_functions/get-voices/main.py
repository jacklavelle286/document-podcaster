import json
import logging
import boto3
import os
from botocore.exceptions import ClientError


def lambda_handler(event, context):
    voices = ["Normal", "Interesting", "Funky"]
    return {
        'statusCode': 200,
        'body': json.dumps(voices)
    }

