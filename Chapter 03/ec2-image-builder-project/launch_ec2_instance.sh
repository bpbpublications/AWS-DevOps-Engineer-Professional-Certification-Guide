#!/bin/bash

# Get Custom Image Arn
image_arn=$(aws imagebuilder list-images \
  --filters "name=name,values=MyTestRecipe" \
  --query 'imageVersionList[0].arn' --output text)
echo "Image Arn is: $image_arn"

# Get Image Details
ami_id=$(aws imagebuilder get-image \
  --image-build-version-arn $image_arn \
  --query 'image.outputResources.amis[0].image' --output text)
echo "Custom Image AMI ID is: $ami_id"

# Launch an EC2 Instance in Public Subnet
instance_id=$(aws ec2 run-instances --image-id $ami_id --instance-type t2.micro --query 'Instances[0].InstanceId' --output text)
echo "Instance ID is: $instance_id"

# Wait for the instance to be in the "running" state
aws ec2 wait instance-running --instance-ids $instance_id

# Describe instances and get PublicDnsName
public_dns_name=$(aws ec2 describe-instances --filters "Name=image-id,Values=$ami_id" --query 'Reservations[].Instances[?ImageId==`'$ami_id'`].PublicDnsName' --output text)
echo "Public DNS Name is: $public_dns_name"
