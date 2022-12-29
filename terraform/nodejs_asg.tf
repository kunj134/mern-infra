## Get AMI ID created from packer using data filter.

data "aws_ami" "nodeami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["kunjan-node-ami"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

## To validate above filter result printed ami_id as output of terraform plan

output ami_id {
  value = data.aws_ami.nodeami.id
  description = "show output as ami id fetched while plan based upon filteration given in data"
}

## ASG module for NodeServers

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"

  name = "kunjan-asg-node"

  min_size                  = 1
  max_size                  = 5
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  ## Launch template for asg nodeservers
  launch_template_name        = "kunjan-lt-node"
  launch_template_description = "Launch template example"
  update_default_version      = true

  image_id = data.aws_ami.nodeami.id
  #image_id          = "ami-0a38df1ea18c458c0"
  instance_type     = "t3a.small"
  key_name          = "kunjankeyaws"
  ebs_optimized     = true
  enable_monitoring = true
  target_group_arns = module.alb.target_group_arns
  iam_instance_profile_name = "codedeploy_role_for_ec2"
  security_groups = [aws_security_group.kunjan-sg-node.id]

  tags = {
    env = "dev"
    owner = "kunjan"
  }
}

## Scaling Policy Defined for NodeServer's ASG

resource "aws_autoscaling_policy" "asg-policy" {
  count                     = 1
  name                      = "asg-cpu-policy"
  autoscaling_group_name    = module.asg.autoscaling_group_name
  estimated_instance_warmup = 60
  policy_type               = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

## Security Group for NodeApp Instance

resource "aws_security_group" "kunjan-sg-node" {
  name        = "kunjan-sg-node"
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
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    security_groups = [aws_security_group.kunjan-sg-lb.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "kunjan-sg-node"
    owner = "kunjan"
    env = "dev"
    terraform = true
  }
}
