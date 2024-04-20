#!/bin/sh
aws iam create-role --role-name ecsTaskExecutionRole --assume-role-policy-document file://ecs-taskexecution-role-trust.json
aws iam attach-role-policy --role-name ecsTaskExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
aws iam get-role --role-name ecsTaskExecutionRole --query "Role.Arn" --output text
