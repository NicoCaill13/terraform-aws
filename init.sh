#!/usr/bin/env bash
name="$1"
environment="$2"
slug="$name $environment"
projectDirectory="$3"
gitDirectory="$4"
port="$5"


[[ ! -z "$6" ]] && nbTarget=$6 || nbTarget=1
[[ ! -z "$7" ]] && subnet=$7 || subnet="private"
[[ ! -z "$8" ]] && isDocker=$8 || isDocker="dockerOff"

terraform init
terraform apply -var "env=$slug" -var "name=$name" -var "isDocker=$isDocker" \
  -var "directory=$projectDirectory" -var "port=$port" -var "subnet=$subnet" \
  -var "nbTarget=$nbTarget" \
  -var "accessKey=$(aws configure get aws_access_key_id)" \
  -var "secretKey=$(aws configure get aws_secret_access_key)" -auto-approve


rm -Rf .terraform/
rm terraform.*
rm .terraform.*
rm ./modules/get-aws-ami/*.txt
rm ./modules/get-aws-asg/*.txt




