#!/bin/sh
####################################################################
# This script creates an S3 bucket and configures it for Website Hosting
####################################################################
bucket_name='static-s3-[YOUR_UNIQUE_IDENTIFIER]'
region='us-east-1'

# Create S3 bucket for website
aws s3api create-bucket \
    --bucket $bucket_name \
    --region $region

# Configure S3 bucket as a website
aws s3api put-bucket-website --bucket $bucket_name --website-configuration file://s3-website.json

# Configure public access for S3 bucket
aws s3api put-bucket-policy --bucket $bucket_name --policy "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"PublicReadGetObject\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"s3:GetObject\",\"Resource\":\"arn:aws:s3:::$bucket_name/*\"}]}"

