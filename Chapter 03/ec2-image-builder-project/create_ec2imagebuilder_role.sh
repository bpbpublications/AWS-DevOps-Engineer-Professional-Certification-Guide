#!/bin/bash

# Create the trust relationship policy JSON file
cat > trust_policy.json << EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOL

# Create the IAM role with the specified trust relationship policy
aws iam create-role --role-name EC2LinuxImageBuildRole --assume-role-policy-document file://trust_policy.json

# Attach the EC2InstanceProfileForImageBuilder  managed policy to the role
aws iam attach-role-policy --role-name EC2LinuxImageBuildRole --policy-arn arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder

# Attach the AmazonSSMManagedInstanceCore managed policy to the role
aws iam attach-role-policy --role-name EC2LinuxImageBuildRole --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore

# Create a custom S3 policy
cat > s3_custom_policy.json << EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::my-ec2-image-builder-bucket"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::my-ec2-image-builder-bucket/*"
        }
    ]
}
EOL

# Create the custom S3 policy
custom_policy_arn=$(aws iam create-policy --policy-name EC2ImageBuilderS3CustomPolicy --policy-document file://s3_custom_policy.json --query 'Policy.Arn' --output text)

# Attach the custom S3 policy to the role
aws iam attach-role-policy --role-name EC2LinuxImageBuildRole --policy-arn $custom_policy_arn

# Create the instance profile
aws iam create-instance-profile --instance-profile-name EC2LinuxImageBuildInstanceProfile 

# Add the IAM Role to the Instance Profile
aws iam add-role-to-instance-profile --instance-profile-name EC2LinuxImageBuildInstanceProfile --role-name EC2LinuxImageBuildRole

# Remove the trust_policy.json file
rm trust_policy.json
rm s3_custom_policy.json


