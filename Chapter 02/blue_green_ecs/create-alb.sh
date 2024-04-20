#!/bin/sh

vpc_id='vpc-e9a21593'
alb_name='blue-green-alb'
tg_gp_1='bluegreen-target-1'
tg_gp_2='bluegreen-target-2'
subnet_1='subnet-ae83e7f2'
subnet_2='subnet-600ba45e'
sg_1='sg-09b281e3c5d723e93'
region='us-east-1'

# Create application load balancer
aws elbv2 create-load-balancer --name $alb_name \
--subnets $subnet_1 $subnet_2 --security-groups $sg_1 --region $region

# Create target group 1
aws elbv2 create-target-group --name $tg_gp_1 --protocol HTTP --port 80 \
--target-type ip --vpc-id $vpc_id --region $region

# Create target group 2
aws elbv2 create-target-group --name $tg_gp_2 --protocol HTTP --port 80 \
--target-type ip --vpc-id $vpc_id --region $region

# Create production listener
alb_arn=$(aws elbv2 describe-load-balancers --names $alb_arn --no-paginate | jq -r '.LoadBalancers[].LoadBalancerArn')
echo "Application laod balancer ARN is : $alb_arn"

tg_gp_1_arn=$(aws elbv2 describe-target-groups --name $target_group_1 --no-paginate | jq -r '.TargetGroups[0].TargetGroupArn')
echo "Target Group 1 Arn is : $tg_gp_1_arn"

# Create production listener
aws elbv2 create-listener --load-balancer-arn $alb_arn --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$tg_gp_1_arn --region $region
