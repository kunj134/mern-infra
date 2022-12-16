# NodeJS AMI Creation Using Packer for MERN Stack Projecy

## Perform Packer installation.

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update && sudo apt-get install packer

## Clone Repo & Build AMI using packer file.

cd mern-infra/nodejs-ami/

packer build ami-nodejs.pkr.hcl

## Verify AMI on AWS Console
