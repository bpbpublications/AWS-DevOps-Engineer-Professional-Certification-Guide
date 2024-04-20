#!/bin/sh
# Create a new IAM role for CloudFormation service with a trust relationship defined in a local JSON file.
aws iam create-role --role-name MyCloudFormationServiceRole --assume-role-policy-document file://../config/cloudformation-role-trust.json
# Attach the AmazonS3FullAccess policy to the MyCloudFormationServiceRole so it can fully manage S3 resources.
aws iam attach-role-policy --role-name MyCloudFormationServiceRole --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
# Apply a custom permissions policy to the role from a local JSON file, allowing necessary CloudFront permissions.
aws iam put-role-policy --role-name MyCloudFormationServiceRole --policy-name cloudfront-permission-policy --policy-document file://../config/cloudfront-permission-policy.json
# Apply another custom permissions policy to the role from a local JSON file, allowing necessary permissions to manage change sets.
aws iam put-role-policy --role-name MyCloudFormationServiceRole --policy-name changeset-permission-policy --policy-document file://../config/changeset-permission-policy.json
# Retrieve the ARN of the created IAM role and output it as text for potential use or verification.
aws iam get-role --role-name MyCloudFormationServiceRole --query "Role.Arn" --output text
