#!/bin/bash

# AWS region where resources will be deployed
aws_region=$1

# Email address where Macie alerts will be sent out
email_address=$2

# Enable AWS Macie
aws macie2 enable-macie --region $aws_region

# Export findings to AWS Security Hub
aws macie2 put-findings-publication-configuration \
  --security-hub-configuration publishClassificationFindings=true,publishPolicyFindings=true

# Enable Security Hub
aws securityhub enable-security-hub --enable-default-standards \
  --region $aws_region

# Create CloudFormation stack
aws cloudformation create-stack --stack-name macie-demo-stack \
  --parameters ParameterKey=SNSTopicEmailAddress,ParameterValue=$email_address \
  --template-body file://../template.yml \
  --region $aws_region
