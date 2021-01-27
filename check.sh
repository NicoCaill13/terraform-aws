#!/usr/bin/env bash
source ./variables.sh

terraform init

terraform plan -var "env=$slug" -var "name=$name" -var "isDocker=$isDocker" \
  -var "directory=$projectDirectory" -var "port=$port" -var "subnet=$subnet" \
  -var "nbTarget=$nbTarget" \
  -var "accessKey=$(aws configure get aws_access_key_id)" \
  -var "secretKey=$(aws configure get aws_secret_access_key)"


rm -Rf .terraform/ && rm .terraform.*