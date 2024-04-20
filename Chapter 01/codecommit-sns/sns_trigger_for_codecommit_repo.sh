#!/bin/sh
#
# sns_trigger_for_codecommit_repo.sh
#
# Get previous created SNS topic ARN
AWS_SNS_TOPIC_ARN=$(aws sns list-topics | jq -r '.Topics[].TopicArn')

# create the trigger definition
cat <<EOF > my_trigger_def.json
{
  "repositoryName": "MySecondRepo",
  "triggers": [
      {
          "destinationArn": "$AWS_SNS_TOPIC_ARN",
          "branches": [],
          "name": "test_sns_trigger",
          "customData": "SNS Trigger For CodeCommit",
          "events": [
              "createReference"
          ]
      }
  ]
}
EOF
 
## create the trigger
aws codecommit put-repository-triggers \
--repository-name "MySecondRepo" \
--cli-input-json file://my_trigger_def.json
 
## get trigger details
aws codecommit get-repository-triggers \
--repository-name "MySecondRepo"
 
## perform a test trigger
aws codecommit test-repository-triggers \
--repository-name "MySecondRepo" \
--cli-input-json file://my_trigger_def.json