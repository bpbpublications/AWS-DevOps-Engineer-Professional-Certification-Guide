#!/bin/sh
########################################################################################
# This script CodeDeploy applicaiton, deployment group and perform blue green deployment
########################################################################################

# Create CodeDeploy applicaiton for ECS computing platform
aws deploy create-application \
     --application-name bluegreen-ecs-deploy-app \
     --compute-platform ECS \
     --region us-east-1

# Create Codedeploy deployment group 
aws deploy create-deployment-group \
     --cli-input-json file://bluegreen-deployment-group.json \
     --region us-east-1

# Create Blue/Green deployment using CodeDeploy
aws deploy create-deployment \
     --cli-input-json file://create-deployment.json \
     --region us-east-1
