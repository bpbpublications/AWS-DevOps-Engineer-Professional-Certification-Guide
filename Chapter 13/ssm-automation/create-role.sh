#!/bin/sh

# Creates a role and attaches a trust policy
aws iam create-role \
    --role-name my-ssm-role \
    --assume-role-policy-document file://trust-policy.json

# Attaches AWS managed policy
aws iam attach-role-policy \
    --role-name my-ssm-role \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM

# Creates instance profile
aws iam create-instance-profile --instance-profile-name \
  my-ec2-instance-profile

# Adds role to the instance profile
aws iam add-role-to-instance-profile --instance-profile-name \
  my-ec2-instance-profile --role-name my-ssm-role
