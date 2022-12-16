# NodeJS AMI Creation Using Packer for MERN Stack Projecy

## Packer installation

###Step: 1 Copy below content as a command to create packer script file.
cat <<EOF > packerinstall.sh
#!/bin/bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
EOF

# Verifying the Installation
# packer
