#!/usr/bin/env bash
export AWS_ACCESS_KEY_ID="$(aws configure get aws_access_key_id --profile terraform)"
export AWS_SECRET_ACCESS_KEY="$(aws configure get aws_secret_access_key --profile terraform)"
export AWS_DEFAULT_REGION="eu-central-1"


export TF_VAR_ENV="develop"
export TF_VAR_SLUG="api"
export TF_VAR_NAME="api-develop-nicocaill13-fr"
export TF_VAR_INSTANCE="t2.micro"
export TF_VAR_AMI="webserver"
export TF_VAR_PUBLIC=false
export TF_VAR_ALIAS= "api"
export TF_VAR_DOMAIN= "nicocaill13.fr"
export TF_VAR_STATUS= "CI"

terraform init

terraform workspace select $TF_VAR_ENV || terraform workspace new $TF_VAR_ENV

terraform plan -lock=false -out terraform.plan


terraform workspace list