import boto3

def lambdahandler(event, context):
    s3client = boto3.client('s3')
    s3bucketname = event['Records'][0]['s3']['bucket']['name']
    s3objectkey = event['Records'][0]['s3']['object']['key']
    
    # Add custom metadata to the dictionary
    my_custom_metadata = {'my_key_1': 'my_value1', 'my_key_2': 'my_value_2'}
    
    s3client.copy_object(Bucket=s3bucketname, CopySource={"Bucket": s3bucketname, "Key": s3objectkey}, Key=s3objectkey, 
                   Metadata=my_custom_metadata, MetadataDirective='REPLACE')
    
    return 'Metadata has been successfully to S3 object'

