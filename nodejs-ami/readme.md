# NodeJS AMI Creation Using Packer for MERN Stack Projecy

## Perform Packer installation & build ami using packer file.

cat <<EOF > packerinstall.sh
#!/bin/bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
EOF
