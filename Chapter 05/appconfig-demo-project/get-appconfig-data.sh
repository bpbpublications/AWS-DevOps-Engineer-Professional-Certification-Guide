#!/bin/bash
#
config_token=$(aws appconfigdata start-configuration-session \
    --application-identifier "dbved23" \
    --environment-identifier "p51j86m" \
    --configuration-profile-identifier "44muqxb" \
    --query 'InitialConfigurationToken' \
    --output text)

echo "Token is: $config_token"

aws appconfigdata get-latest-configuration \
    --configuration-token $config_token my-configdata.json 
