module "pritunl" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name = "kunjan-Pritunl-Host"
  ami                    = "ami-0530ca8899fac469f"
  instance_type          = "t3a.small"
  key_name               = "kunjankeyaws"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.pritunl-sg.id]
  subnet_id              = element(module.vpc.public_subnets, 0)
  ## Instance profile given to provide ssm-agent access for session manager to access server without ssh port allowed 
  iam_instance_profile = resource.aws_iam_instance_profile.iam_profile_ssm.name
  user_data = filebase64("pritunl.sh")
  tags = {
    Terraform   = "true"
    Environment = "stg"
  }
}
#security group for pritunl
resource "aws_security_group" "pritunl-sg" {
  name = "Pritunl-SG"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    description = "TLS from VPC"
    from_port   = 1700
    to_port     = 1700
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "kunjan-Pritunl-SG"
    Owner = "kunjan"
  }
}

## Create Instance Profile for SSM-AGENT to access sessionmanager
resource "aws_iam_instance_profile" "iam_profile_ssm" {
  name = "test_profile_ssm"
  role = aws_iam_role.kunj-iam-role-ssm.name
}
## Created role to attach with instance profile
resource "aws_iam_role" "kunj-iam-role-ssm" {
  name = "kunj-iam-role-ssm"
  description= "Created role for EC2"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Action": "sts:AssumeRole",
"Principal": {"Service": "ec2.amazonaws.com"},
"Effect": "Allow"
}
}
EOF
}
## Attaching policy of AmazonSSMManagedInstanceCore with IAM Role
resource "aws_iam_role_policy_attachment" "resource-ssm-attach" {
role = aws_iam_role.kunj-iam-role-ssm.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
