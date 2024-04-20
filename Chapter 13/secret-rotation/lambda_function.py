import boto3
import json
import uuid

from botocore.exceptions import ClientError

def lambda_handler(event, context):
    secret_name = "MyTestAPIKeySecret"
    region_name = "us-east-1"

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name,
    )

    get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
    )
        
    if 'SecretString' in get_secret_value_response:
        response = client.update_secret(
        SecretId='MyTestAPIKeySecret',
        SecretString=generate_new_api_key()
        )
        print(response)    
    else:
        binary_secret_data = get_secret_value_response['SecretBinary']

def generate_new_api_key():
    # generate new api key
    return str(uuid.uuid4())
