#!/bin/bash

# Create the cross-account IAM role
role_arn=$(aws iam create-role \
    --role-name CrossAccountCodePipelineRole \
    --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::[DEV_ACCOUNT_ID]:root"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }' --query 'Role.Arn' --output text)

echo "Created role: $role_arn"

# Attach the CrossAccountCodePipelineAccessPolicy policy
aws iam attach-role-policy \
    --role-name CrossAccountCodePipelineRole \
    --policy-arn "arn:aws:iam::[TEST_ACCOUNT_ID]:policy/CrossAccountCodePipelineAccessPolicy"

echo "Attached policy: CrossAccountCodePipelineAccessPolicy"

# Attach the KMSAPIActionsPolicy policy
aws iam attach-role-policy \
    --role-name CrossAccountCodePipelineRole \
    --policy-arn "arn:aws:iam::[TEST_ACCOUNT_ID]:policy/KMSAPIActionsPolicy"

echo "Attached policy: KMSAPIActionsPolicy"
