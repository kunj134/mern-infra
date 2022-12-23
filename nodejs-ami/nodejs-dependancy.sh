sudo apt update && sudo apt upgrade -y
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install collectd nodejs awscli ruby-full -y
sudo apt install gcc make -y
sudo npm install pm2@latest -g
sudo wget https://s3.us-west-2.amazonaws.com/amazoncloudwatch-agent-us-west-2/ubuntu/amd64/latest/amazon-cloudwatch-agent.d>sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto > /tmp/logfile
rm -rf amazon-cloudwatch-agent.deb
rm -rf install
sudo systemctl enable codedeploy-agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:/kunjan/cloudwatch
sudo systemctl start amazon-cloudwatch-agent.service
sudo systemctl enable amazon-cloudwatch-agent.service
sudo systemctl status amazon-cloudwatch-agent.service
