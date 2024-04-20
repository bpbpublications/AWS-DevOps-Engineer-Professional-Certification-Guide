#!/bin/bash
stack_name="aws-crud-stack"

# Get ApiEndPoint from Cloudformation Outputs
api_endpoint=$(aws cloudformation describe-stacks --stack-name $stack_name --query 'Stacks[0].Outputs[?OutputKey==`ApiEndpoint`].OutputValue' --output text)

echo "API EndPoint is $api_endpoint"

# Insert five Products in DynamoDB table
for i in {1..5}
do
  curl -X "PUT" -H "Content-Type: application/json" \
  -d "{\"id\": \"$((300 + i))\", \"price\": $((500 + i * 100)), \"name\": \"product-$i\"}" \
  $api_endpoint
done

# Get all Products from DynamoDB table
curl $api_endpoint
