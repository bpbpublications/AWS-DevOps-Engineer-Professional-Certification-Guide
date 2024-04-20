import os
import gzip
import base64
import json
import logging
import boto3
from botocore.exceptions import ClientError

logger_name = logging.getLogger(__name__)

def processing_log_events(event: dict) -> dict:
    # Decode and decompress log events
    decoded_base64_payload = base64.b64decode(event.get("awslogs").get("data"))
    uncompressed_base64_payload = gzip.decompress(decoded_base64_payload)
    my_payload = json.loads(uncompressed_base64_payload)
    return my_payload

def processing_err_payload(
    payload: dict,
) -> str("Parsed response from payload!"):
    # Parse payload
    log_group_name = payload.get("logGroup")
    log_stream_name = payload.get("logStream")
    log_events = payload.get("logEvents")
    lambdafunct_name = payload.get("logGroup").split("/")[-1]
    err_message = "\t".join(levent["message"] for levent in log_events)
    return log_group_name, log_stream_name, lambdafunct_name, err_message

def ret_function(
    statuscode=200,
    msg="I am glad, it worked!",
    headers={"Content-Type": "application/json"},
    isBase64Encoded=False,
) -> dict:
    return {
        "statusCode": statuscode,
        "headers": headers,
        "body": json.dumps({"message": msg}),
        "isBase64Encoded": isBase64Encoded,
    }

def sending_email_notification(
    log_group_name: str,
    log_stream_name: str,
    lambdafunct_name: str,
    err_message: str,
) -> str("Sending email notification!"):
    my_sns_client = boto3.client("sns")
    MY_SNS_TOPIC_ARN = os.environ.get("MY_SNS_TOPIC_ARN", None)
    if not MY_SNS_TOPIC_ARN:
        logger_name.error("MY_SNS_TOPIC_ARN is missing!")
        return ret_function(status_code=500, message="Error occured in sending email notification!")

    emailbody = f"""
    ---------------------------------------------------------------------------
    | Name of Log group ::: {log_group_name}
    | Name of Log Stream ::: {log_stream_name}
    | Details of error message ::: {err_message}
    --------------------------------------------------------------------------
    """

    emailsub = f"Errors found in log events | {lambdafunct_name}"

    try:
        my_sns_client.publish(
            TargetArn=MY_SNS_TOPIC_ARN, Subject=emailsub, Message=emailbody
        )
    except ClientError as e:
        logger_name.error(e)

def lambdafunc_handler(event, context):
    my_payload = processing_log_events(event)
    (
        log_group_name,
        log_stream_name,
        lambdafunct_name,
        err_message,
    ) = processing_err_payload(my_payload)
    sending_email_notification(log_group_name, log_stream_name, lambdafunct_name, err_message)

    return ret_function()

