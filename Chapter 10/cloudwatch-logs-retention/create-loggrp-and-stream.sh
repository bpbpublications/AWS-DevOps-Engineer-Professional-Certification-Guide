#!/bin/bash

# CloudWatch log group name
loggroup="test-log-group"

# CloudWatch log stream name
logstream="test-log-stream"

# Create CloudWatch log group
aws logs create-log-group --log-group-name $loggroup

# Create CloudWatch log stream
aws logs create-log-stream --log-group-name $loggroup --log-stream-name $logstream

# Define json object for events
events_json='[
  {
    "timestamp": 1433190184356,
    "message": "Example-Event-1"
  },
  {
    "timestamp": 1433190184358,
    "message": "Example-Event-2"
  },
  {
    "timestamp": 1433190184360,
    "message": "Example-Event-3"
  }
]'

# Write the contents of json object to file
echo "$events_json" > file.json

# Verify the contents of json file
cat file.json

# Put log events
aws logs put-log-events --log-group-name $loggroup \
  --log-stream-name $logstream \
  --log-events file://file.json
