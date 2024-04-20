#!/bin/bash

# Create the IAM role and attach the required policies
ROLE_NAME="S3BucketDeploymentCFNRole"

# Create the trust policy JSON
cat > trust_policy.json << EOL
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudformation.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOL

# Create the role with the trust policy
aws iam create-role \
  --role-name $ROLE_NAME \
  --assume-role-policy-document file://trust_policy.json

# Attach AmazonS3FullAccess Managed Policy
aws iam attach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn "arn:aws:iam::aws:policy/AmazonS3FullAccess"

# Clean up the trust policy JSON file
rm trust_policy.json

