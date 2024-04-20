#!/bin/sh
aws iam create-role --role-name MyCodeDeployServiceRole --assume-role-policy-document file://codedeploy-role-trust.json
aws iam attach-role-policy --role-name MyCodeDeployServiceRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole
aws iam put-role-policy --role-name MyCodeDeployServiceRole --policy-name sns-permission-policy --policy-document  file://sns-permission-policy.json
aws iam get-role --role-name MyCodeDeployServiceRole --query "Role.Arn" --output text
