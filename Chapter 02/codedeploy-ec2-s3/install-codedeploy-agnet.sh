#!/bin/sh

# Shell Script to Install  CodeDeploy agent on Amazon Linux OS
sudo yum update
sudo yum install ruby
sudo yum install wget
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# Check if agent is running
sudo service codedeploy-agent status
