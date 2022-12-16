# NodeJS AMI Creation Using Packer for MERN Stack Projecy

# Step:1 Install Packer 
#################################################################################################################################
# Step:1 Packer installation

#################################################################################################################################
cat <<EOF > packerinstall.sh
#!/bin/bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
EOF
# Verifying the Installation
# packer
