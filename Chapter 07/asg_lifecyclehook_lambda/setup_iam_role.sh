#!/bin/bash

# Create an IAM role for Lambda
aws iam create-role --role-name EC2LifecycleHookLambdaRole --assume-role-policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}'

# Attach the AWSLambdaBasicExecutionRole policy to the role
aws iam attach-role-policy --role-name EC2LifecycleHookLambdaRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Add inline policy to the role to allow autoscaling:CompleteLifecycleAction
aws iam put-role-policy --role-name EC2LifecycleHookLambdaRole --policy-name AutoScalingLifecyclePolicy --policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "autoscaling:CompleteLifecycleAction",
      "Resource": "arn:aws:autoscaling:us-east-1:[AWS_ACCOUNT_ID]:autoScalingGroup:30d41a84-2a53-413d-95bb-7b5ce00005e2:autoScalingGroupName/MY-ASG"
    }
  ]
}'

# Add inline policy to the role to allow ec2:CreateImage
aws iam put-role-policy --role-name EC2LifecycleHookLambdaRole --policy-name CreateImagePolicy --policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CreateImage",
      "Effect": "Allow",
      "Action": "ec2:CreateImage",
      "Resource": "*"
    }
  ]
}'

