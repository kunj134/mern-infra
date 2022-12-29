#!/bin/bash
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv E162F504A20CDF15827F718D4B7C549A058F8B6B
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
echo "deb http://repo.pritunl.com/stable/apt focal main" | sudo tee /etc/apt/sources.list.d/pritunl.list
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update
apt-get install mongodb-server pritunl -y
sudo systtemctl stop mongod
sudo systemctl start mongod
sudo systemctl start pritunl

## Installing SSM Client to connect server without ssh key and without allowing 22 or ssh port in SG of Pritunl server (make sure aws -cli is installed in the local system)
## SSM agent policy has been created in tf code 
sudo mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo apt install amazon-ssm-agent.deb -y 
sudo systemctl stop snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent.service

## Use ssm command to connect server without ssh key or any port [command :aws ssm start-session --target instance-id]
## you needs to install ssm plugin on the local system https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html



