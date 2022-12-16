packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


source "amazon-ebs" "kunjan-node-ami" {
  ami_name      = "kunjan-node-ami"
  instance_type = "t3a.small"
  region        = "us-west-2"
  source_ami = "ami-0530ca8899fac469f"
  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.kunjan-node-ami"
  ]
  provisioner "shell" {
  script       = "nodejs-dependancy.sh"
}
}
