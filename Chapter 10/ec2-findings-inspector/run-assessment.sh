#!/bin/bash
#
stack_name="ec2-inspector-runassessment-stack"
assessment_template_arn=$(aws cloudformation describe-stacks \
  --stack-name $stack_name --query 'Stacks[0].Outputs[?OutputKey==`EC2AssessmentTemplateArn`].OutputValue' --output text)
echo "Assessment Template Arn is : $assessment_template_arn"

# Start an assessment run
aws inspector start-assessment-run \
  --assessment-run-name ec2-assessmentrun \
  --assessment-template-arn $assessment_template_arn



