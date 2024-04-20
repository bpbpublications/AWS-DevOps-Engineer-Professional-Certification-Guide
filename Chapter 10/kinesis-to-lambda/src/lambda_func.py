import base64
def handler(event, context):
    for record in event['Records']:
       kinesis_decoded_payload=base64.b64decode(record["kinesis"]["data"])
       print("Kinesis decoded payload: " + str(kinesis_decoded_payload))
