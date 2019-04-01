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

# resource "aws_launch_configuration" "launch_conf_withuserdata" {
#   count                    = "${length(var.userdata_path) == 0 ? 0 : 1}"
#   name_prefix                 = "${var.name}"
#   image_id                    = "${data.aws_ami.linux2.id}"
#   instance_type               = "${var.instance_type}"
#   key_name                    = "${var.keypair_name}"
#   security_groups = ["${var.sg_id}"]
#   iam_instance_profile = "${var.iam_instance_profile}"
#   associate_public_ip_address = true
#   enable_monitoring           = false
#   user_data = "${var.userdata_path}"

#   root_block_device = {
#     volume_type           = "gp2"
#     volume_size           = "8"
#     delete_on_termination = true
#   }

#   lifecycle = {
#     create_before_destroy = true
#   }
#}

resource "aws_launch_configuration" "launch_conf_withuserdata" {
  name_prefix                 = "${var.name}"
  image_id                    = "${data.aws_ami.linux2.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.keypair_name}"
  security_groups = ["${var.sg_id}"]
  iam_instance_profile = "${var.iam_instance_profile}"
  associate_public_ip_address = true
  enable_monitoring           = false
  user_data = "${file(var.userdata_path)}"

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

resource "aws_autoscaling_group" "asg" {
  name                 = "${var.name}"
  launch_configuration = "${aws_launch_configuration.launch_conf_withuserdata.name}"
  #launch_configuration = "${length(var.userdata_path) == 0 ?  aws_launch_configuration.launch_conf_withuserdata.name : aws_launch_configuration.launch_conf_withoutuserdata.name }"
  min_size             = 1
  max_size             = 3
  vpc_zone_identifier =  ["${slice(var.subnets, 0, 2)}"]
  health_check_grace_period = 30
  lifecycle {
    create_before_destroy = true
  }
  tag = {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }
}