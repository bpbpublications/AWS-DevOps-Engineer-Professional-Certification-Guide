#!/bin/sh
##########################################################################
# This script provisions ECS cluster, Two task definition and  ECS Service  
##########################################################################

ecs_cluster_name='blue-green-ecs-cluster'
aws_region='us-east-1'

# Create ECS Cluster
aws ecs create-cluster \
     --cluster-name $ecs_cluster_name \
     --region $aws_region

# Register Task definition for Blue application
aws ecs register-task-definition \
     --cli-input-json file://blue-fargate-task-def.json \
     --region $aws_region

# Register Task definition for Green application
aws ecs register-task-definition \
     --cli-input-json file://green-fargate-task-def.json \
     --region $aws_region

# Create ECS Service for Blue application
aws ecs create-service \
                 --cli-input-json file://bluegreen-fargate-service.json \
                 --region $aws_region
