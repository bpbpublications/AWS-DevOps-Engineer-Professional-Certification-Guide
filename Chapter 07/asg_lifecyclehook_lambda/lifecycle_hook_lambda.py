import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    instance_id = event['detail']['EC2InstanceId']

    # Create an image of the instance
    image = ec2.create_image(
        InstanceId=instance_id,
        Name='Image of instance ' + instance_id,
        Description='Image created by Lambda function',
        NoReboot=True
    )

    # Notify Auto Scaling to continue lifecycle action
    autoscaling = boto3.client('autoscaling')
    response = autoscaling.complete_lifecycle_action(
        LifecycleHookName='TerminateInstanceLifecycleHook',
        AutoScalingGroupName='MY-ASG',
        LifecycleActionToken=event['detail']['LifecycleActionToken'],
        LifecycleActionResult='CONTINUE'
    )

    return {
        'statusCode': 200,
        'body': response
    }
