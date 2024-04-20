#!/bin/bash

# Get data bucket name from cloudformation outputs
data_s3_bucket=$(aws cloudformation describe-stacks \
    --stack-name "macie-demo-stack" --query 'Stacks[0].Outputs[?OutputKey==`MacieDataBucket`].OutputValue' --output text)

# Remove data file (.csv) from S3 bucket
data_file_name="sample-data-macie.csv"
aws s3 rm s3://$data_s3_bucket/$data_file_name

# Remove resources created by CloudFormation stack
aws cloudformation delete-stack --stack-name macie-demo-stack

# Disable Macie
aws macie2 disable-macie

# Disable Security Hub
aws securityhub disable-security-hub
