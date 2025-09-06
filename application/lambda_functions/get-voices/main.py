import json
import logging
import boto3
import os
from botocore.exceptions import ClientError


def lambda_handler(event, context):
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from transcribe!')
    }

