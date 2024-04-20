#!/bin/bash

#Create a patch base pipeline
baseline_id=$(aws ssm create-patch-baseline --name "Linux-Production-Baseline-AutoApproval" \
    --operating-system "AMAZON_LINUX_2" \
    --approval-rules 'PatchRules=[{PatchFilterGroup={PatchFilters=[{Key=SEVERITY,Values=[Critical]},{Key=CLASSIFICATION,Values=[Security]}]},ApproveAfterDays=3}]' \
    --description "Baseline containing all updates approved for Security patches" \
    --query 'BaselineId' --output text)

echo "Patch baseline id is: $baseline_id"

# Register path baseline to a patch group
aws ssm register-patch-baseline-for-patch-group \
  --baseline-id $baseline_id \
  --patch-group "Patch Group for EC2 Instance"

# Create maintenance window
window_id=$(aws ssm create-maintenance-window \
 --name "Maintenance-Window-PROD-EveryTues" \
 --tags "Key=env,Value=prod" \
 --schedule "cron(0 0 19 ? * TUE *)" \
 --schedule-timezone "America/New_York" \
 --duration 1 \
 --cutoff 0 \
 --no-allow-unassociated-targets --query 'WindowId' --output text)

echo "Window Id is: $window_id"

# Register patch group with maintenance windows
window_target_id=$(aws ssm register-target-with-maintenance-window \
  --window-id $window_id \
  --targets "Key=tag:env,Values=prod" \
  --owner-information "EC2 Instance" \
  --resource-type "INSTANCE" --query 'WindowTargetId' --output text)

echo "Window Target Id is: $window_target_id"

# Register patch task to install missing security update on EC2 instance
window_task_id=$(aws ssm register-task-with-maintenance-window \
  --window-id $window_id \
  --targets "Key=WindowTargetIds,Values=$window_target_id" \
  --task-arn "AWS-RunPatchBaseline" \
  --task-type "RUN_COMMAND" \
  --max-concurrency 2 \
  --max-errors 1 \
  --priority 1 \
  --task-invocation-parameters "RunCommand={Parameters={Operation=Install}}" \
  --query 'WindowTaskId' --output text)

echo "Window task id is: $window_task_id"
