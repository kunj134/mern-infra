# MernStack project Infra Setup

### Clone the repo and change to terraform directory
clone https://github.com/kunj134/mern-infra.git
cd mern-infra/terraform

### Use aws-cli to configure the credentials or use following commands. 
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export AWS_REGION="us-west-2"

### Create infra setup using terraform commands
$ terraform init
$ terraform plan -out tf.plan
$ terraform apply tf.plan

### Note 
Refer to provider.tf to configure central tagging for the resources which willl create from terraform.
Refer to locals.tf to configure values of defined variables. 
