#!/bin/sh
aws iam create-role --role-name ecsCodeDeployRole --assume-role-policy-document file://ecs-codedeploy-role-trust.json
aws iam attach-role-policy --role-name ecsCodeDeployRole --policy-arn arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS
aws iam get-role --role-name ecsCodeDeployRole --query "Role.Arn" --output text
