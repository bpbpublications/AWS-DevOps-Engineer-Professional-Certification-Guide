#!/bin/sh
aws iam create-role --role-name codedeploy-ec2-inst-profile --assume-role-policy-document file://codedeploy-ec2-trust.json
aws iam put-role-policy --role-name codedeploy-ec2-inst-profile  --policy-name codedeploy-s3-permission --policy-document file://codedeploy-s3-permission.json
aws iam create-instance-profile --instance-profile-name codedeploy-ec2-inst-profile
aws iam add-role-to-instance-profile --instance-profile-name codedeploy-ec2-inst-profile --role-name codedeploy-ec2-inst-profile
