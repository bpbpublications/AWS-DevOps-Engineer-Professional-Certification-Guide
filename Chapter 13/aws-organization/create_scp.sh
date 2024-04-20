#/bin/bash
# Get Organization Root ID
org_root_id=$(aws organizations list-roots \
  --query 'Roots[0].Id' --output text)
echo "Root Id is: $org_root_id"

# Enable SCP for Organization
aws organizations enable-policy-type \
  --root-id $org_root_id \
  --policy-type SERVICE_CONTROL_POLICY

# Create SCP Policy
policy_id=$(aws organizations create-policy \
    --content file://policy.json \
    --name RestrictCloudTrailOperation \
    --type SERVICE_CONTROL_POLICY \
    --description "Restrict CloudTrail Operations to member account" \
    --query 'Policy.PolicySummary.Id' --output text)
echo "Policy ID: $policy_id"

# Get OU Id
ou_id=$(aws organizations list-organizational-units-for-parent \
  --parent-id $org_root_id \
  --query 'OrganizationalUnits[0].Id' \
  --output text)
echo "OU Id is: $ou_id"

# Apply SCP Policy to OU
aws organizations attach-policy \
    --policy-id $policy_id \
    --target-id $ou_id
