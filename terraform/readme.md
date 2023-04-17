# Infra Setup using terraform

## Step:1 Clone the repo and change to terraform directory

git clone -b <Branch-Name> https://github.com/Brandscope/terraform.git

cd terraform/env/#Environment-Directory#/

## Step:2 Use aws-cli to configure the credentials or use following commands.

$ export AWS_ACCESS_KEY_ID="#Your-AccessKey-Id#"

$ export AWS_SECRET_ACCESS_KEY="#Your-SecretKey-Id#"

$ export AWS_REGION="#region-name#"

## Step:3 changes in values of defined variables as per the environment

Refer to provider.tf to configure central tagging for the resources which will create from terraform.

Refer to locals.tf to configure values of defined variables.


## Step:4 Create infra setup using terraform commands

$ terraform init

$ terraform plan -out tf.plan

$ terraform apply tf.plan

