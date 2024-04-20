#!/bin/bash
data_s3_bucket=$(aws cloudformation describe-stacks \
    --stack-name "macie-demo-stack" \
    --query 'Stacks[0].Outputs[?OutputKey==`MacieDataBucket`].OutputValue' --output text)
aws s3 cp ../data/sample-data-macie.csv s3://$data_s3_bucket
