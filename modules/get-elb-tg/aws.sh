#!/usr/bin/env bash
eval "$(jq -r '@sh "export ID=\(.autoscaling)"')"
autoscalingExist=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name ${ID//\"/} | jq '.AutoScalingGroups[].AutoScalingGroupName')
if [[ -z "$autoscalingExist" ]]; then  autoscalingExist=none; fi

#kleo25-dev-keepcoolpro-fr
jq -n --arg id "${autoscalingExist//\"/}" '{"autoscaling":$id}'
