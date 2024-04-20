#!/bin/bash
stack_name="kinesis-to-lambda-stack"

stream_name=$(aws cloudformation describe-stacks --stack-name $stack_name --query 'Stacks[0].Outputs[?OutputKey==`MyKinesisDataStream`].OutputValue' --output text)

echo "Kinesis Datastream Name is $stream_name"

for i in $(seq 1 2 10)
do
   aws kinesis put-record --stream-name $stream_name --partition-key 1 --data "Hello World $i times"
done


