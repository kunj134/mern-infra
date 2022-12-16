## Three mongodb instances

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["mongo0", "mongos1", "mongo2"])

  name = "kunjan-${each.key}"

  ami                    = "ami-0530ca8899fac469f"
  instance_type          = "t3a.small"
  key_name               = "kunjankeyaws"
  monitoring             = true
  vpc_security_group_ids = [resource.aws_security_group.kunjan-sg-mongo.id]
  subnet_id              = module.vpc.private_subnets[0]

  user_data = filebase64("mongo_install.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
    owner = "kunjan"
  }
}

## Security Group of Mongo Instances
resource "aws_security_group" "kunjan-sg-mongo" {
  name        = "kunjan-sg-mongo"
  description = "Allow TLS inbound and outbund traffic"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.pritunl-sg.id]
    #cidr_blocks      = [module.vpc.vpc_cidr_block]
  }
 ingress {
    description      = "TLS from VPC"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    security_groups = [aws_security_group.kunjan-sg-node.id]
    self = true
 }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "kunjan-sg-mongo"
    owner = "kunjan"
    env = "dev"
    terraform = true
  }
}
