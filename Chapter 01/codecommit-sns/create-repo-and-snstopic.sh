#!/bin/sh

# Create a new codecommit repository
aws codecommit create-repository --repository-name MySecondRepo \
--repository-description "My Second CodeCommit Repository" 

# Create a new SNS topic with an email subscription
my_sns_toppic_arn=$(aws sns create-topic \
  --name "my_sns_topic" \
  --tags "Key=name,Value=testapp" \
  --query 'TopicArn' \
  --output text)
 
# create a sns topic email subscription
aws sns subscribe \
  --topic-arn $my_sns_toppic_arn \
  --protocol email \
  --notification-endpoint xyz@gmail.com


