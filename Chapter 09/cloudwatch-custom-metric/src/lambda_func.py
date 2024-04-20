import boto3

cloudwatch = boto3.client('cloudwatch', region_name='us-east-1')

def lambdafunc_handler(event, context):

    params = {
        'MetricData': [],
        'Namespace': 'MyMetricNamespace'
    }

    params['MetricData'].append({
        'MetricName': 'LatencyByEdgeLocation',
        'Dimensions': [
            { 'Name': 'EdgeLocation', 'Value': event['LocationCode'] }
        ],
        'Timestamp': 'Wednesday, Jan 18, 2023 8:28:20 PM',
        'Unit': 'Milliseconds',
        'Value': event['TimeToFirstByte']
    })

    print(cloudwatch.put_metric_data(**params))

