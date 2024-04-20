#!/bin/bash

# Create KMS key
kms_key_id=$(aws kms create-key --description "kms key for systems manager param store" \
  --key-usage ENCRYPT_DECRYPT --query KeyMetadata.KeyId --output text)

echo "kms key id is : $kms_key_id"

aws ssm put-parameter \
    --name "my-test-parameter" \
    --value "my-test-parameter-value" \
    --type "SecureString" \
    --key-id $kms_key_id \
    --overwrite
