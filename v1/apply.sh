#!/usr/bin/env bash
source ./scripts/variables.sh

terraform init

terraform apply -var "env=$slug" -var "name=$name" -var "isDocker=$isDocker" \
  -var "directory=$projectDirectory" -var "port=$port" -var "subnet=$subnet" \
  -var "nbTarget=$nbTarget" \
  -var "accessKey=$(aws configure get aws_access_key_id)" \
  -var "secretKey=$(aws configure get aws_secret_access_key)" -auto-approve


rm -Rf .terraform/ && rm .terraform.* ./modules/get-aws-ami/*.txt ./modules/get-aws-asg/*.txt