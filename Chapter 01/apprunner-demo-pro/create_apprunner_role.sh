#!/bin/bash

# Create the trust relationship policy JSON file
cat > trust_policy.json << EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "build.apprunner.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOL

# Create the IAM role with the specified trust relationship policy
aws iam create-role --role-name AppRunnerECRAccessRole --assume-role-policy-document file://trust_policy.json

# Attach the AWSAppRunnerServicePolicyForECRAccess managed policy to the role
aws iam attach-role-policy --role-name AppRunnerECRAccessRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess

# Remove the trust_policy.json file
rm trust_policy.json


