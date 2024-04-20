#!/bin/bash

# Create organization
aws organizations create-organization \
  --query 'Organization.[Id]' \
  --output text

# Create account
request_id=$(aws organizations create-account \
  --email "testuser-YOUR-UNIQUE-IDENTIFIER@gmail.com"  \
  --account-name "devops-account" \
  --query 'CreateAccountStatus.[Id]' \
  --output text)

echo "Request Id is: $request_id"

while true; do
    result=$(aws organizations describe-create-account-status --create-account-request-id $request_id)
    state=$(echo $result | jq -r '.CreateAccountStatus.State')
    if [[ $state == "SUCCEEDED" ]]; then
        echo "Account creation completed successfully"
        break
    elif [[ $state == "FAILED" ]]; then
        echo "Account creation failed"
        exit 1
    else
        echo "Waiting for account creation to complete..."
        sleep 10
    fi
done

# Get Account Id
account_id=$(aws organizations describe-create-account-status \
  --create-account-request-id $request_id \
  --query 'CreateAccountStatus.[AccountId]' \
  --output text)

echo "Account Id: $account_id"

# Get root id of organization
root_id=$(aws organizations list-roots --query 'Roots[0].[Id]' \
 --output text)
echo "Root Id is: $root_id"

# Create OU
ou_id=$(aws organizations create-organizational-unit \
  --parent-id $root_id \
  --name="OU" \
  --query 'OrganizationalUnit.[Id]' \
  --output text)

echo "OU Id is: $ou_id"

# Move account to OU
aws organizations move-account \
  --account-id $account_id \
  --source-parent-id $root_id \
  --destination-parent-id $ou_id
