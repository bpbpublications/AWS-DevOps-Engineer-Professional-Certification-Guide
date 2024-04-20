#!/bin/sh
email_address=$1

aws_region='us-east-1'

# Create an SNS Topic for RDS event subscription
topic_arn=$(aws sns create-topic \
    --name rds-event-topic \
    --region $aws_region \
    --output text)

echo "Topic Arn is : $topic_arn"

# Create a subscription to provided email address to the SNS topic
aws sns subscribe \
        --topic-arn $topic_arn \
        --protocol email \
        --no-return-subscription-arn \
        --notification-endpoint $email_address \
        --region $aws_region

# Create a RDS event subscription
aws rds create-event-subscription \
        --subscription-name my-rds-subscription \
        --sns-topic-arn $topic_arn \
        --source-type db-cluster \
        --event-categories failover \
        --source-ids my-aurora-cluster \
        --region $aws_region \
        --enabled
