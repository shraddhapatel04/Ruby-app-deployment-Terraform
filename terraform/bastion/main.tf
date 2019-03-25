###########################################
######## IAM Role ##################
###########################################
resource "aws_iam_role" "bastion-role" {
  name = "${var.name}-bastion-role"

  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bastions" {
  name = "${var.name}.bastions"
  role = "${aws_iam_role.bastion-role.name}"
}


###########################################
######## Security Groups ##################
###########################################
resource "aws_security_group" "bastion_allow_ssh" {
  name        = "${var.name}-bastion"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]# add a CIDR block here
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

###########################################
######## AMI Filetering ##################
###########################################
data "aws_ami" "linux2" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"] # Canonical
}

###########################################
######## Launch Configuration #############
###########################################

resource "aws_launch_configuration" "bastions" {
  name_prefix                 = "${var.name}-bastion-"
  image_id                    = "${data.aws_ami.linux2.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.keypair_name}"
  security_groups             = ["${aws_security_group.bastion_allow_ssh.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.bastions.id}"
  associate_public_ip_address = true
  enable_monitoring           = false

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = "8"
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

###########################################
######## Auto Scaling Group ###############
###########################################
resource "aws_autoscaling_group" "bastion" {
  name                 = "${var.name}-bastion"
  launch_configuration = "${aws_launch_configuration.bastions.name}"
  min_size             = 1
  max_size             = 3
  vpc_zone_identifier =  ["${slice(var.public_subnets, 0, 2)}"]
  health_check_grace_period = 30
  lifecycle {
    create_before_destroy = true
  }
  tag = {
    key                 = "Name"
    value               = "${var.name}.bastions"
    propagate_at_launch = true
  }
}